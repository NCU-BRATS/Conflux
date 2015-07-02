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

shared_context 'issue sprint with project members and labels' do
  include_context 'project with members'
  before(:example) do
    @issue = FactoryGirl.create(:issue)
    @issue.project = @project
    @issue.user    = @members[0]
    @sprint = FactoryGirl.create(:sprint)
    @sprint.project = @project
    @sprint.user = @members[0]
    @label = FactoryGirl.create(:label)
    @label.project = @project
  end
end

shared_context 'commentable with project and user' do
  include_context 'project with members'
  before(:example) do
    @commentable = FactoryGirl.create(:issue)
    @commentable.project   = @project
    @commentable.user      = @members[0]
  end
end

shared_context 'comment with commentable project and user' do
  include_context 'commentable with project and user'
  before(:example) do
    Faker::Lorem.sentence
    @comment = Comment.new
    @comment.content = Faker::Lorem.sentence
    @comment.user = @members[0]
    @comment.commentable = @commentable
    @comment.save(validate: false)
  end
end
