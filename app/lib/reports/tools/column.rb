module Reports
  module Tools
    class Column
      attr_reader :title

      def initialize(title)
        @title = title
      end

      def decorate_value(data, _options = {})
        ReportValue.new(data)
      end

      def to_s
        title
      end
    end
  end
end
