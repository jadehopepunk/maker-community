require 'image_processing/mini_magick'

module Wp
  class BookablePerson < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    default_scope { where(post_type: 'bookable_person') }

    def build_price(base_amount:)
      amount = per_person + base_amount

      case post_title.downcase
      when 'full', 'non member', 'non-member'
        Prices::Full.new(per_person: amount)
      when 'concession'
        Prices::Concession.new(per_person: amount)
      when 'member', 'mci member', 'community member', 'member/concession'
        Prices::Member.new(per_person: amount)
      when 'spectator', 'challenge participant'
        Prices::Free.new
      else
        raise "Unknown price type: \"#{post_title}\" for #{inspect}"
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
