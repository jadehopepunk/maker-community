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

    def apply(_scope)
      raise NotImplementedError, "Override this function to do something (for filter #{title})"
    end
  end

  class PlanSearchFilter < SearchFilter
    def plan
      @plan ||= Plan.find_by_name(value)
    end

    def title
      plan.title
    end

    def apply(scope)
      scope.with_plan(plan)
    end
  end

  class EventDateSearchFilter < SearchFilter
    SCOPES = ['future'].freeze

    def title
      value
    end

    def apply(scope)
      raise ArgumentError unless SCOPES.include?(value)

      scope.send(value)
    end
  end

  class << self
    FACTORIES = {
      'plan' => SearchFilters::PlanSearchFilter,
      'event_date' => SearchFilters::EventDateSearchFilter
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
    super
  end

  def apply(scope)
    each do |filter|
      scope = filter.apply(scope)
    end
    scope
  end
end
