module ContentHelper
  def render_html_without_line_breaks(content)
    simple_format content.to_s.html_safe
  end
end
