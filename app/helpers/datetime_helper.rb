module DatetimeHelper
  def format_datetime(datetime, options = {})
    seperator = options[:seperator] || ': '

    content_tag :span, class: 'datetime' do
      format_date(datetime) + seperator + format_time(datetime)
    end
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

    datetime.strftime(format_string)
  end

  def format_date(date)
    return nil if date.nil?

    show_year = (date.year != Date.today.year)

    format_string = '%a, %b %d'
    format_string += ', %Y' if show_year

    content_tag :span, date.strftime(format_string), class: 'date'
  end
end
