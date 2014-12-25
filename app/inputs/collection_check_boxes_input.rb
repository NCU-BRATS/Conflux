class CollectionCheckBoxesInput < CollectionRadioButtonsInput

  protected

  def build_nested_boolean_style_item_tag(collection_builder)
    tag = String.new
    tag << '<div class="ui checkbox">'.html_safe
    tag << collection_builder.check_box + collection_builder.label
    tag << '</div>'.html_safe
    return tag.html_safe
  end

end
