module Wp
  class TermRelationship < Wp::Base
    self.table_name = 'wp_term_relationships'

    belongs_to :term_taxonomy
    belongs_to :post, class_name: 'Wp::Post', foreign_key: 'object_id'

    def self.suppress_composite_primary_key(_pk); end
  end
end
