class ProjectSearch
  include ActiveAttr::Model
  attribute :query
  attribute :type, default: 'issue'
  attribute :project

  HIGHLIGHT_TAG = 'a__conflux_em__'
  HIGHLIGHT_CLOSE_TAG = 'a__e_conflux_em__'

  def index
    ProjectsIndex
  end

  def search
    # We can merge multiple scopes
    [query_string, project_id_filter, aggregations,
     post_filter, highlight].compact.reduce(:merge)
  end

  # Using query_string advanced query for the main query input
  def query_string
    index.query(query_string: {fields: [:title, :name, :content, :comments, :'labels.title'],
                                query: query, default_operator: 'AND'}) if query?
  end

  def aggregations
    index.aggregations(types: {terms: {field: '_type', min_doc_count: 0}})
  end

  def highlight
    index.highlight(fields: {
      title: {},
      name: {},
      content: {
        pre_tags: [HIGHLIGHT_TAG], post_tags: [HIGHLIGHT_CLOSE_TAG],
        fragment_size: 150, number_of_fragments: 3, no_match_size: 150
      },
      comments: {
        fragment_size: 300, number_of_fragments: 3, no_match_size: 300
      }
    })
  end

  # Simple term filter for project id.
  def project_id_filter
    index.filter(term: {project_id: project.id})
  end

  def post_filter
    index.post_filter(term: {_type: type})
  end

end
