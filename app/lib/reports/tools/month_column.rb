module Reports
  module Tools
    class MonthColumn
      class MonthValue < ReportValue
        def to_s
          show_year = (data.year != Date.today.year)

          format_string = '%B'
          format_string += ', %Y' if show_year

          data.start_date.strftime(format_string)
        end
      end

      def decorate_value(data, _options = {})
        MonthValue.new(data)
      end

      def to_s
        'Month'
      end
    end
  end
end
