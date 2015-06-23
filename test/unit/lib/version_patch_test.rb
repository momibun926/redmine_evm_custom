require File.expand_path('../../../test_helper', __FILE__)

class VersionPatchTest < ActiveSupport::TestCase
  fixtures :projects

ActiveRecord::Fixtures.create_fixtures(Redmine::Plugin.find_by_id(:redmine_evm).directory + '/test/fixtures/',
                                         [ :issues, 
                                           :time_entries,
                                           :time_entries,
                                           :versions,
                                           :baselines,
                                           :baseline_issues,
                                           :baseline_versions ])         

  def setup
    @baseline = Baseline.find_by_id(1)
    @project = @baseline.project
  end

  def test_if_version_is_excluded
    version = @project.versions.find_by_id(165)
    assert_equal false, version.is_excluded(@baseline)

    baseline_version = version.baseline_versions.where(baseline_id: @baseline).first
    baseline_version.exclude = true
    baseline_version.save
    assert_equal true, version.is_excluded(@baseline)
  end

  def test_maximum_chart_date
    version = @project.versions.find_by_id(165)
    assert_equal Date.new(2014,03,17), version.maximum_chart_date(@baseline)
  end
  
end