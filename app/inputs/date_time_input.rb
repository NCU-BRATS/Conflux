class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input_html_options
    {:data => {:toggle => 'datetime-picker'}}.deep_merge(super)
  end

  def use_html5_inputs?
    true
  end
end
