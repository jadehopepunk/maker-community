module Reports
  module Tools
    class ChangeColumn < Column
      class ChangeValue
        attr_reader :original, :current

        def initialize(original, current)
          @original = original
          @current = current
        end

        def to_s
          return '' if original.to_i == 0

          delta = current - original

          as_percentage(delta.to_f / original.to_f)
        end

        private

        def as_percentage(fraction)
          percentage = (fraction * 100)
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
