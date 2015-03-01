module LabelsHelper

  def project_label_names
    @project.labels.pluck(:title)
  end

  def render_colored_label(label, options = {})
    options = options.symbolize_keys

    label_color = label.color || Label::DEFAULT_COLOR
    text_color  = text_color_for_bg(label_color)

    classes = ( options[:class] || '' )
    styles  = ( options[:style] || '' )

    content_tag :span, class: 'ui label colored ' + classes, style: "background:#{label_color};color:#{text_color};" + styles do
      label.name
    end
  end

  def suggested_colors
    %w(#D9534F #F0AD4E #428BCA #5CB85C #34495E #7F8C8D #8E44AD #FFECDB)
  end

  def text_color_for_bg(bg_color)
    r, g, b = bg_color.slice(1,7).scan(/.{2}/).map(&:hex)

    if (r + g + b) > 500
      '#333'
    else
      '#FFF'
    end
  end

end
