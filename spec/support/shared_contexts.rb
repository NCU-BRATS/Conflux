shared_context 'project with members' do
  before(:context) do
    @project, @members = FactoryHelper.create_project_with_members
  end
end

shared_context 'member jwts' do
  before(:context) do
    @jwts = @members.map do |member|
      post '/api/v1/authentication', usermail: member.email, password: member.password
      jwt = JSON.parse(response.body)
      jwt['token']
    end
  end
end

shared_context 'project with members and issues' do
  include_context 'project with members'

  before(:context) do
    @issues = 3.times.map { FactoryGirl.create(:issue) }
    @issues.each do |issue|
      issue.project = @project
      issue.save(validate: false)
    end
  end
end

shared_context 'project with members and sprints' do
  include_context 'project with members'

  before(:context) do
    @sprints = 3.times.map { FactoryGirl.create(:sprint) }
    @sprints.each do |sprint|
      sprint.project = @project
      sprint.save(validate: false)
    end
  end
end

shared_context 'project with members and polls' do
  include_context 'project with members'

  before(:context) do
    @polls = 3.times.map { FactoryGirl.create(:poll) }
    @polls.each do |poll|
      poll.project = @project
      poll.save(validate: false)
    end
  end
end

shared_context 'project with members and attachments' do
  include_context 'project with members'

  before(:context) do
    @attachments = 3.times.map { FactoryGirl.create(:attachment) }
    @attachments.each do |attachment|
      attachment.project = @project
      attachment.save(validate: false)
    end
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

shared_context 'notice' do
  include_context 'project with members'
  before(:example) do
    @notice = Notice.new
    @notice.save(validate: false)
  end
end

shared_context  'message with its channel project and member' do
  include_context 'channel with project and members'
  before(:example) do
    @message = FactoryGirl.build(:message)
    @message.channel = @channel
    @message.user    = @members[0]
    @message.save
  end
end

shared_context 'label with color title project and member' do
  include_context 'project with members'
  before(:example) do
    @label = FactoryGirl.build(:label)
    @label.project = @project
    @label.save
  end
end

shared_context 'post with project and creator' do
  include_context 'project with members'
  before(:example) do
    @post = FactoryGirl.build(:post)
    @post.user = @members[0]
    @post.project = @project
    @post.save(validate: false)
  end
end

shared_context 'snippet with project and creator' do
  include_context 'project with members'
  before(:example) do
    @snippet = FactoryGirl.build(:snippet)
    @snippet.user = @members[0]
    @snippet.project = @project
    @snippet.save(validate: false)
  end
end
