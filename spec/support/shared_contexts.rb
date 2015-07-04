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
    @poll.save
    @options[0].voted_by(@members[0])
    @options[0].save
  end
end

shared_context 'channel with project and members' do
  include_context 'project with members'
  before(:example) do
    @channel = FactoryGirl.build(:channel)
    @channel.project = @project
    @channel.members << @members[0]
    @channel.save
  end
end

shared_context 'first poll option was voted by first member' do
  include_context 'poll with options'
  before(:example) do
    @options[0].voted_by(@members[0])
    @options[0].save
  end
end

shared_context 'issue sprint with project members and labels' do
  include_context 'project with members'
  before(:example) do
    @issue = FactoryGirl.build(:issue)
    @issue.project = @project
    @issue.user    = @members[0]
    @issue.save
    @sprint = FactoryGirl.build(:sprint)
    @sprint.project = @project
    @sprint.user = @members[0]
    @sprint.save
    @label = FactoryGirl.build(:label)
    @label.project = @project
    @label.save
  end
end

shared_context 'commentable issue with project and user' do
  include_context 'project with members'
  before(:example) do
    @commentable = FactoryGirl.build(:issue)
    @commentable.project = @project
    @commentable.user    = @members[0]
    @commentable.save
    @issue = @commentable
  end
end

shared_context 'comment with commentable project and user' do
  include_context 'commentable issue with project and user'
  before(:example) do
    @comment = FactoryGirl.build(:comment)
    @comment.user = @members[0]
    @comment.commentable = @commentable
    @comment.save
  end
end
