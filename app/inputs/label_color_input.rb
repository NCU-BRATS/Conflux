class LabelColorInput < SimpleForm::Inputs::Base

  def input( wrapper_options )
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    input_html = '<div class="ui labeled input"><div class="ui label label-color-preview">&nbsp</div>'
    input_html << @builder.text_field(attribute_name, merged_input_options)
    input_html << '</div>'
    input_html.html_safe
  end

end
