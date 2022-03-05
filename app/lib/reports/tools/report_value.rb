module Reports
  module Tools
    class ReportValue
      def initialize(text)
        @text = text
      end

      def to_s
        @text
      end
    end
  end
end
