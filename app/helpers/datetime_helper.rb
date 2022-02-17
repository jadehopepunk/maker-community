module DatetimeHelper
  def format_datetime(datetime, options = {})
    seperator = options[:seperator] || ': '

    content_tag :span, class: 'datetime' do
      format_date(datetime) + seperator + format_time(datetime)
    end
  end

  def format_time(datetime)
    return nil if datetime.blank?

    content_tag :span, class: 'time' do
      datetime.strftime('%l:%M%P')
    end
  end

  def format_date(date)
    show_year = (date.year != Date.today.year)

    format_string = '%a, %b %d'
    format_string += ', %Y' if show_year

    content_tag :span, date.strftime(format_string), class: 'date'
  end
end
