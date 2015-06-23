class BaselineVersion < ActiveRecord::Base
  include Schedulable
  unloadable

  belongs_to :baseline 
  has_many :baseline_issues, dependent: :destroy
  belongs_to :version, :foreign_key => 'original_version_id'
  attr_protected :id

  def start_date
    @start_date ||= baseline_issues.minimum('start_date') || created_on.to_date #created_on of the normal original version. rename it in te database
  end

  def end_date
    update_hours ? @end_date ||= end_date_when_updated_hours.to_date : @end_date ||= effective_date || baseline.due_date
  end

  private
  
    def end_date_when_updated_hours 
      is_closed ? baseline_issues.maximum('closed_on') : effective_date || baseline.due_date
    end
end