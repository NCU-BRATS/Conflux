class CollectionSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input_html_options
    super.reverse_merge({:data => {:toggle => 'selectize'}})
  end
end
