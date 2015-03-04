class ProjectSearch
  include ActiveAttr::Model
  attribute :query
  attribute :type, default: 'issue'
  attribute :project

  HIGHLIGHT_TAG = 'a__conflux_em__'
  HIGHLIGHT_CLOSE_TAG = 'a__e_conflux_em__'

  FILTER_MAP = {
    'status'          => 'status',
    'label'           => 'labels.title',
    'channel'         => 'channel_id',
    'attachment_type' => 'type'
  }

  def index
    ProjectsIndex
  end

  def search
    # We can merge multiple scopes
    scopes = [query_string, project_id_filter, type_agg, post_filter, highlight]
    scopes << label_agg           if issue?
    scopes << status_agg          if issue? || sprint?
    scopes << channel_agg         if message?
    scopes << attachment_type_agg if attachment?
    scopes.compact.reduce(:merge)
  end

  # Using query_string advanced query for the main query input
  def query_string
    index.query(
      multi_match: {
        query: query,
        fields: [:title, :name, :content, :comments, :'labels.title']
      }
    ) if query?
  end

  def type_agg
    index.aggregations(types: {terms: {field: '_type', min_doc_count: 0}})
  end

  def highlight
    index.highlight(
      fields: {
        title: {number_of_fragments: 0},
        name:  {number_of_fragments: 0},
        content: {
          pre_tags: [HIGHLIGHT_TAG], post_tags: [HIGHLIGHT_CLOSE_TAG],
          fragment_size: 150, number_of_fragments: 3, no_match_size: 150
        },
        comments: {
          fragment_size: 300, number_of_fragments: 3, no_match_size: 300
        }
      }
    )
  end

  # Simple term filter for project id.
  def project_id_filter
    index.filter(term: {project_id: project.id})
  end

  def post_filter
    must = [{term: {_type: type}}]

    FILTER_MAP.each do |filter, field|
      must << {
        bool: { should: @attributes[filter].map {|term| {term: {field => term}}} }
      } if @attributes[filter]
    end

    index.post_filter(bool: { must: must })
  end

  FILTER_MAP.each do |filter_name, field|
    define_method("#{filter_name}_agg") do
      index.aggregations(filter_name => {
        filter: {term: {_type: type}},
        aggs: {filter_name => {terms: {field: field}}}
      })
    end
  end

  ['issue', 'sprint', 'attachment', 'message'].each do |type|
    define_method("#{type}?") do
      self.type == type
    end
  end

  ['status', 'label', 'attachment_type', 'channel'].each do |filter|
    define_method(filter) do
      (@attributes[filter] || []).join(',')
    end
    define_method("#{filter}=") do |arg|
      @attributes[filter] = arg.split(',').uniq
    end
  end

end
