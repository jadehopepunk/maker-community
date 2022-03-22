module DatetimeHelper
  def format_datetime_html(datetime, options = {})
    seperator = options[:seperator] || ': '

    content_tag :span, class: 'datetime' do
      format_date_html(datetime) + seperator + format_time_html(datetime)
    end
  end

  def format_datetime_text(datetime, options = {})
    seperator = options[:seperator] || ': '

    format_date_text(datetime) + seperator + format_time_text(datetime)
  end

  def format_time_html(datetime)
    content_tag :span, class: 'time' do
      format_time_text(datetime)
    end
  end

  def format_time_text(datetime)
    return nil if datetime.blank?

    format_string = '%-l'
    format_string += ':%M' if datetime.min.nonzero?
    format_string += '%P'

    datetime.in_time_zone.strftime(format_string)
  end

  def format_date_text(date)
    return nil if date.nil?

    show_year = (date.year != Date.current.year)

    format_string = '%a, %b %d'
    format_string += ', %Y' if show_year
    date.in_time_zone.strftime(format_string)
  end

  def format_date_html(date)
    return nil if date.nil?

    content_tag :span, format_date_text(date), class: 'date'
  end

  def format_month_text(month)
    show_year = (month.year != Date.current.year)
    result = month.name.to_s
    result += ", #{month.year}" if show_year
    result
  end
end
