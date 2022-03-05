module Reports
  module Tools
    class ReportValue
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def to_s
        @data.to_s
      end
    end
  end
end
