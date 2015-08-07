class MentionService
  def self.parse_mentioned(content, project)
    content, mentioned_resource = parse_mentioned_resources(['member'], content)
    content, mentioned_project_resource = parse_mentioned_project_resources(['attachment', 'issue', 'sprint', 'poll', 'message'], content, project)
    return content, mentioned_resource.merge(mentioned_project_resource)
  end

  def self.parse_mentioned_resources(resources, content)
    mentioned_list = {}

    resources.each do |resource|
      # Use resource name to construct the mention service that used to parse mentioned resource
      service = "#{resource.camelize}MentionService".constantize
      parse_result = service.new.parse_mention(content)

      # Replace original content with parsed content
      content = parse_result[:filtered_content]

      # Put the id of mentioned resources to mentioned list
      mentioned_resources = parse_result["mentioned_#{resource.pluralize}".to_sym]
      mentioned_ids = mentioned_resources.map(&:id)
      mentioned_list.merge!(resource.pluralize => mentioned_ids.sort)
    end
    return content, mentioned_list
  end

  def self.parse_mentioned_project_resources(resources, content, project)
    mentioned_list = {}

    resources.each do |resource|
      # Use resource name to construct the mention service that used to parse mentioned resource
      service = "#{resource.camelize}MentionService".constantize
      parse_result = service.new.parse_mention(content, project)

      # Replace original content with parsed content
      content = parse_result[:filtered_content]

      # Put the id of mentioned resources to mentioned list
      mentioned_resources = parse_result["mentioned_#{resource.pluralize}".to_sym]
      mentioned_ids = mentioned_resources.map(&:sequential_id)
      mentioned_list.merge!(resource.pluralize => mentioned_ids.sort)
    end
    return content, mentioned_list
  end
end
