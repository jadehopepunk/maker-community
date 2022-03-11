module Reports
  module Tools
    class ChangeColumn < Column
      class ChangeValue < ReportValue
        attr_reader :original

        def initialize(original, current)
          @original = original
          super(current)
        end

        def to_s
          return '' unless valid_change?
          return '' if original.to_i == 0

          as_percentage(delta.to_f / original.to_f)
        end

        def prefix
          return nil unless valid_change?
          return { type: :change_up } if delta > 0
          return { type: :change_down } if delta < 0

          nil
        end

        private

        def valid_change?
          !original.nil?
        end

        def delta
          data - original
        end

        def as_percentage(fraction)
          percentage = fraction.abs * 100
          "#{percentage.round(0)}%"
        end
      end

      attr_reader :column_index

      def initialize(title, column_index:)
        @column_index = column_index
        super(title)
      end

      def decorate_value(_data, index:, row_values:, last_row:)
        original = last_row.nil? ? 0 : last_row[column_index]
        current = row_values[column_index]
        ChangeValue.new(original, current)
      end

      def to_s
        title
      end
    end
  end
end
