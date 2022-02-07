class SearchFilters < Array
  class SearchFilter
    attr_reader :key, :value

    def initialize(key, value)
      @key = key
      @value = value
    end

    def title
      "#{key}: #{value}"
    end
  end

  class PlanSearchFilter < SearchFilter
    def plan
      @plan ||= Plan.find_by_name(value)
    end

    def title
      plan.title
    end
  end

  class << self
    FACTORIES = {
      'plan' => SearchFilters::PlanSearchFilter
    }

    def search_filter_class_for(key)
      FACTORIES[key] || SearchFilter
    end

    def from_params(filter_params)
      input = (filter_params || []).map do |input|
        key, value = input.split('|')
        factory = search_filter_class_for(key)
        factory.new(key, value)
      end
      new input
    end
  end

  def initialize(input)
    input.each do |filter|
      self << filter
    end
  end
end
