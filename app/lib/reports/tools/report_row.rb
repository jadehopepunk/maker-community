module Reports
  module Tools
    class ReportRow
      attr_reader :values, :columns, :last_row

      def initialize(columns:, values:, last_row:)
        @columns = columns
        @values = values
        @last_row = last_row
      end

      def each(&block)
        columns.each_with_index do |column, index|
          value = values[index]
          block.call column.decorate_value(value, index:, row_values: values, last_row:)
        end
      end

      def [](index)
        values[index]
      end
    end
  end
end
