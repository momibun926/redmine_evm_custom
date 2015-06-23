# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

class RedmineEvm::TestCase
  include ActionDispatch::TestProcess

  def self.prepare
      # User 2 Manager (role 1) in project 1, email jsmith@somenet.foo
      # User 3 Developer (role 2) in project 1

      Role.where(id: [1,2]).each do |r|
        r.permissions << :view_evms
        r.save
      end

      Role.where(id: [1,2]).each do |r|
        r.permissions << :view_baselines
        r.save
      end

      Role.find_by_id(1) do |r|
        r.permissions << :manage_baselines
        r.save
      end

      Project.where(id: [1,2,3,4,5]).each do |project|
        EnabledModule.create(:project => project, :name => 'evm')
      end

  end
end