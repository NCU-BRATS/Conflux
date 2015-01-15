class CollectionSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input_html_options
    {:data => { :toggle => 'selectize' }}.deep_merge(super)
  end

  def input(wrapper_options = nil)
    data_options = input_html_options[:data].symbolize_keys
    return super if data_options[:'resource-path'].blank?

    label_method, value_method = detect_collection_methods
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    @builder.select(
      attribute_name,
      collection.map {|e| [e.send(label_method), e.send(value_method), { data: {data: e.to_json} } ]},
      input_options, merged_input_options
    )
  end
end
