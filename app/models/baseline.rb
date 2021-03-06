class Baseline < ActiveRecord::Base
  include Redmine::SafeAttributes
  include Schedulable
  include Forecastable
  unloadable

  belongs_to :project
  has_many :baseline_issues, dependent: :destroy
  has_many :baseline_versions, dependent: :destroy

  validates :name, :due_date, :presence => true
  attr_protected :id

  before_create {update_baseline_status("#{l(:label_old_baseline)}", project_id)}
  after_create {update_baseline_status("#{l(:label_current_baseline)}", project_id)}

  acts_as_customizable

  safe_attributes 'name',
  'description',
  'due_date'

  def create_versions versions, versions_to_exclude, update_estimated_hours
    unless versions.nil?
      versions.each do |version|
        versions_to_exclude.nil? ? exclude = false : exclude =  versions_to_exclude.include?(version.id)
        update_estimated_hours == "1" ? update_hours = true : update_hours = false
        baseline_versions.create original_version_id: version.id, effective_date: version.effective_date, name: version.name, created_on: version.created_on,exclude: exclude, update_hours: update_hours, is_closed: version.closed?
      end
    end
  end

  def create_issues issues, update_estimated_hours
    unless issues.nil?
      issues.each do |issue|
        update_estimated_hours == "1" ? update_hours = true : update_hours = false
        baseline_issue = BaselineIssue.new original_issue_id: issue.id, done_ratio: issue.done_ratio, status: issue.status.name, due_date: issue.due_date, start_date: issue.start_date, exclude: false, update_hours: update_hours, estimated_hours: issue.estimated_hours, spent_hours: issue.spent_hours, closed_on: issue.closed_on, is_closed: issue.closed?, is_leaf: issue.leaf?

        baseline_version = self.baseline_versions.find_by_original_version_id(issue.fixed_version_id)
        unless baseline_version.nil?
          baseline_issue.baseline_version_id = baseline_version.id
          baseline_issue.exclude = baseline_version.exclude
        end
        baseline_issue.save
        baseline_issues << baseline_issue
      end
    end
  end

  def versions_to_exclude operator, selected_target_versions
    target_versions = []
    all_versions = project.versions.map(&:id)
    unless selected_target_versions.nil?
      target_versions = selected_target_versions.collect{|v| v.to_i}
    end
    
    if operator == "is"
      all_versions - target_versions #All the other not selected versions are excluded.
    elsif operator == "is not"
      target_versions
    elsif operator == "any"
      target_versions
    elsif operator == "none"
      all_versions
    end
  end

  def get_targeted_versions
    baseline_versions.where(exclude: false).map(&:original_version_id)
  end

  def update_baseline_status status, project_id
    project = Project.find_by_id(project_id) 
    baseline = project.baselines.last 
    if baseline 
      baseline.state = status 
      baseline.save
    end
  end

  def start_date #delete start date from the database
    @start_date = baseline_issues.where(exclude: false).minimum(:start_date) || project.created_on #SCOPE WHERE
  end

  def end_date 
    update_hours ? @end_date ||= maximum_end_date_when_update_hours.to_date : @end_date ||= due_date
  end

  #Date
  def today_date
    Time.now.to_date
  end

  #Budget at Completion (BAC)
  def project_budget_at_completion_hours 
    self.budget_at_completion.round(2)
  end
  def project_budget_at_completion_days
    (self.budget_at_completion / 8).round(1)
  end

  #Plan Value (PV)
  def today_pv_hours 
    self.planned_value.round(2)
  end
  def today_pv_days
    (today_pv_hours / 8 ).round(1)
  end

  #Earned Value (EV)
  def today_ev_hours
    project.earned_value(self).round(2)
  end
  def today_ev_days
    (today_ev_hours / 8).round(1)
  end

  #Actual Cost (AC)
  def today_ac_hours
    project.actual_cost(self).round(2)
  end
  def today_ac_days
    (today_ac_hours / 8).round(1)
  end

  #Schedule Performance Index (SPI)
  def schedule_performance_index 
    planned_value != 0 ? (project.earned_value(self).to_f / self.planned_value).round(2) : 0
  end

  #Cost Performance Index (CPI)
  def cost_performance_index
    project.actual_cost(self) != 0 ? (project.earned_value(self).to_f / project.actual_cost(self)).round(2) : 0
  end

  #Critical Ratio (CR)
  def critical_ratio 
    (schedule_performance_index *  cost_performance_index).round(2)
  end

  #Schedule Variance (SV)
  def schedule_variance_hours
    (project.earned_value(self) - self.planned_value).round(2)
  end
  def schedule_variance_days
    (schedule_variance_hours / 8 ).round(1)
  end

  #Cost Variance (CV)
  def cost_variance_hours
    (project.earned_value(self) - project.actual_cost(self)).round(2)
  end
  def cost_variance_days
    (cost_variance_hours / 8).round(1)
  end

  #Difference planed end date, forecast earned end date.
  def difference_bac_eac_days
    (self.estimate_at_completion_date - end_date).to_i
  end

  #Completed earned value
  def completed_ev
    ((today_ev_hours / project_budget_at_completion_hours) * 100).round
  end

  private
    def maximum_end_date_when_update_hours
      baseline_issues.maximum('closed_on') || due_date
    end

end
