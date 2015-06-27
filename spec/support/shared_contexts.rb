shared_context 'project with members' do
  before(:context) do
    @project, @members = FactoryHelper.create_project_with_members
  end
end

shared_context 'poll with options' do
  before(:example) do
    @poll, @options = FactoryHelper.create_poll_with_options
    @poll.project   = @project
    @poll.user      = @members[0]
    @options[0].voted_by(@members[0])
  end
end
