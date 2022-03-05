module Reports
  module Tools
    class ReportRow
      attr_reader :values, :columns

      def initialize(columns:, values:)
        @columns = columns
        @values = values
      end

      def each(&block)
        columns.each_with_index do |column, index|
          value = values[index]
          block.call column.decorate_value(value)
        end
      end
    end
  end
end
