module Reports
  module Tools
    class ReportRow
      attr_reader :values

      def initialize(values:)
        @values = values
      end

      def each(&block)
        values.each(&block)
      end
    end
  end
end
