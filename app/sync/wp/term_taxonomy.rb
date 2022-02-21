module Wp
  class TermTaxonomy < Wp::Base
    self.table_name = 'wp_term_taxonomy'

    belongs_to :term
    has_many :term_relationships, class_name: 'Wp::TermRelationship', foreign_key: 'term_taxonomy_id'

    scope :product_tags, -> { where(taxonomy: 'product_tag') }
  end
end
