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
    [query_string, project_id_filter, type_agg, label_agg,
     status_agg, attachment_type_agg, channel_agg, post_filter, highlight].compact.reduce(:merge)
  end

  # Using query_string advanced query for the main query input
  def query_string
    index.query(query_string: {fields: [:title, :name, :content, :comments, :'labels.title'],
                                query: query, default_operator: 'AND'}) if query?
  end

  def type_agg
    index.aggregations(types: {terms: {field: '_type', min_doc_count: 0}})
  end

  def label_agg
    index.aggregations(label: {
      filter: {term: {_type: type}},
      aggs: {label: {terms: {field: 'labels.title'}}}
    }) if issue?
  end

  def status_agg
    index.aggregations(status: {
      filter: {term: {_type: type}},
      aggs: {status: {terms: {field: 'status'}}}
    }) if issue? || sprint?
  end

  def attachment_type_agg
    index.aggregations(attachment_type: {
      filter: {term: {_type: type}},
      aggs: {attachment_type: {terms: {field: 'type', min_doc_count: 0}}}
    }) if attachment?
  end

  def channel_agg
    index.aggregations(channel: {
      filter: {term: {_type: type}},
      aggs: {channel: {terms: {field: 'channel_id'}}}
    }) if message?
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
    index.post_filter(bool: {
      must: {term: {_type: type}},
      should: {}
    })
  end

  def issue?
    type == 'issue'
  end

  def sprint?
    type == 'sprint'
  end

  def attachment?
    type == 'attachment'
  end

  def message?
    type == 'message'
  end

end
