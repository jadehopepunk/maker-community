require 'image_processing/mini_magick'

module Wp
  class BookablePerson < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    default_scope { where(post_type: 'bookable_person') }

    def build_price(base_amount:)
      amount = per_person + base_amount

      case post_title
      when 'Full'
        Prices::Full.new(per_person: amount)
      when 'Concession'
        Prices::Concession.new(per_person: amount)
      when 'Member'
        Prices::Member.new(per_person: amount)
      else
        raise "Unknown price type: #{price_type}"
      end
    end

    def per_person
      cost + block_cost
    end

    def cost
      meta['cost'].to_f
    end

    def block_cost
      meta['block_cost'].to_f
    end
  end
end
