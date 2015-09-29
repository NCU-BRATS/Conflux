class ProjectsIndex < Chewy::Index
  settings analysis: {
    analyzer: {
      default: {
        type: 'custom',
        char_filter: ['html_strip'],
        tokenizer: 'smartcn_tokenizer',
        filter: ['lowercase']
      }
    }
  }

  define_type Issue.includes(:comments, :labels) do
    field :title
    field :sequential_id, type: 'integer'
    field :project_id,    type: 'integer'
    field :user_id,       type: 'integer'
    field :assignee_id,   type: 'integer'
    field :sprint_id,     type: 'integer'
    field :status,        index: 'not_analyzed'
    field :begin_at,      type: 'date'
    field :due_at,        type: 'date'
    field :created_at,    type: 'date'
    field :comments,      value: -> { comments.map(&:content) }
    field :labels do
      field :title, index: 'not_analyzed'
      field :color, index: 'not_analyzed'
    end
  end

  define_type Sprint.includes(:issues, :comments) do
    field :title
    field :sequential_id, type: 'integer'
    field :project_id,    type: 'integer'
    field :user_id,       type: 'integer'
    field :status,        index: 'not_analyzed'
    field :begin_at,      type: 'date'
    field :due_at,        type: 'date'
    field :created_at,    type: 'date'
    field :comments,      value: -> { comments.map(&:content) }
    field :issues,        value: -> { issues.map(&:title) }
  end

  define_type Attachment.includes(:comments) do
    field :name
    field :content
    field :type,       index: 'not_analyzed'
    field :language,   index: 'not_analyzed'
    field :project_id, type: 'integer'
    field :user_id,    type: 'integer'
    field :created_at, type: 'date'
    field :comments,   value: -> { comments.map(&:content) }
  end

  define_type Message.includes(channel: :project) do
    field :content
    field :channel_id, type: 'integer'
    field :project_id, type: 'integer', value: -> { project.id }
    field :user_id,    type: 'integer'
    field :created_at, type: 'date'
  end

  define_type Poll.includes(:comments, :options) do
    field :title
    field :sequential_id, type: 'integer'
    field :project_id,    type: 'integer'
    field :user_id,       type: 'integer'
    field :status,        index: 'not_analyzed'
    field :allow_multiple_choice, type: 'boolean'
    field :created_at,    type: 'date'
    field :comments,      value: -> { comments.map(&:content) }
    field :options do
      field :title
      field :poll_id, type: 'integer'
      field :votes_total, type: 'integer'
    end
  end
end
