module Reports
  module Tools
    class MonthColumn < Column
      class MonthValue < ReportValue
        def to_s
          show_year = (data.year != Date.today.year)

          format_string = '%B'
          format_string += ', %Y' if show_year

          data.start_date.strftime(format_string)
        end
      end

      def initialize(title = 'Month')
        super(title)
      end

      def decorate_value(data, _options = {})
        MonthValue.new(data)
      end

      def numeric?
        false
      end
    end
  end
end
