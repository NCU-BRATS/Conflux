shared_context 'project with members' do
  before(:context) do
    @project, @members = FactoryHelper.create_project_with_members
  end
end

shared_context 'poll with options' do
  include_context 'project with members'
  before(:example) do
    @poll, @options = FactoryHelper.create_poll_with_options
    @poll.project   = @project
    @poll.user      = @members[0]
    @options[0].voted_by(@members[0])
  end
end

shared_context 'channel with project and members' do
  include_context 'project with members'
  before(:example) do
    @channel = FactoryGirl.create(:channel)
    @channel.project = @project
    @channel.members << @members[0]
  end
end

shared_context 'first poll option was voted by first member' do
  include_context 'poll with options'
  before(:example) do
    @options[0].voted_by(@members[0])
  end
end
