module ReportHelper
  def table_prefix(prefix)
    return nil if prefix.nil?

    send("table_prefix_#{prefix[:type]}", prefix)
  end

  def table_prefix_change_up(_prefix)
    content_tag :span, '&#9650;'.html_safe, class: 'change-up'
  end

  def table_prefix_change_down(_prefix)
    content_tag :span, '&#9660;'.html_safe, class: 'change-down'
  end
end
