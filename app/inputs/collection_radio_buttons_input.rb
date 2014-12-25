class CollectionRadioButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput

  protected

  def collection_block_for_nested_boolean_style
    proc { |builder| build_nested_boolean_style_item_tag(builder) }
  end

  def build_nested_boolean_style_item_tag(collection_builder)
    tag = String.new
    tag << '<div class="ui radio checkbox">'.html_safe
    tag << collection_builder.radio_button + collection_builder.label
    tag << '</div>'.html_safe
    return tag.html_safe
  end

end
