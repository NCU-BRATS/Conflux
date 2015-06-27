module FactoryHelper
  class << self

    def create_project_with_members(n = 1)
      project = FactoryGirl.create(:project)
      members = n.times.map { FactoryGirl.create(:user) }
      members.each { |member| project.members << member }
      return [project, members]
    end

    def create_poll_with_options(n = 2)
      poll = FactoryGirl.create(:poll)
      options = n.times.map { FactoryGirl.create(:polling_option) }
      options.each { |option| poll.options << option }
      return [poll, options]
    end

  end
end
