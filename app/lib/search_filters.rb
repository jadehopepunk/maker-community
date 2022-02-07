class SearchFilters < Array
  class SearchFilter
    def initialize(key, value)
      @key = key
      @value = value
    end
  end

  class << self
    def from_params(filter_params)
      input = filter_params.map { |value| SearchFilter.new(*value.split('|')) }
      new input
    end
  end

  def initialize(input)
    self << input
  end
end
