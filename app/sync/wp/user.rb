module Wp
  class User < Wp::Base
    self.table_name = 'wp_users'

    has_many :user_meta, class_name: 'Wp::UserMeta', foreign_key: 'user_id'

    class << self
      def dest_class
        ::User
      end

      def sync
        includes(:user_meta).find_each(&:import_or_update)
      end
    end

    def import_or_update
      if existing_dest
        update_existing
      else
        import_new
      end
    end

    def existing_dest
      @dest ||= dest_class.where(wordpress_id: self.ID).first
    end

    def import_new
      dest = dest_class.new(
        password: user_pass,
        **shared_attributes,
        wordpress_id: self.ID,
        created_at: user_registered
      )
      dest.save!
      insert_new_inductions!(dest)
      puts "imported user #{dest.display_name}"
    end

    def update_existing
      dest = existing_dest

      dest.assign_attributes shared_attributes
      if dest.changed? || dest.address&.changed?
        dest.save!
        puts "updated user #{dest.display_name}"
      end
      insert_new_inductions!(dest)
    end

    def shared_attributes
      {
        email: user_email.downcase,
        display_name:,
        address_attributes:,
        phone: meta['billing_phone']
      }
    end

    def address_attributes(prefix: 'billing_')
      result = {
        address_1: meta["#{prefix}address_1"],
        address_2: meta["#{prefix}address_2"],
        city: meta["#{prefix}city"],
        state: meta["#{prefix}state"],
        postcode: meta["#{prefix}postcode"],
        country_code: meta["#{prefix}country"]
      }

      has_result = result.values.reject(&:blank?).compact.any?

      has_result ? result : {}
    end

    def insert_new_inductions!(record)
      insert_inductions!(record, inductions - record.inductions.pluck(:title))
    end

    def insert_inductions!(record, new_inductions)
      return if new_inductions.empty?

      puts "about to create inductions #{new_inductions.inspect}"

      new_inductions.each do |induction_name|
        record.user_inductions.create! induction_id: induction_id_for(induction_name)
      end
    end

    def induction_id_for(induction_name)
      Induction.find_or_create_by!(title: induction_name).id
    end

    def meta
      @meta ||= PostMeta.convert_to_hash(user_meta)
    end

    def inductions
      value = meta['_wc_memberships_profile_field_inductions']
      return [] if value.blank?

      PHP.unserialize meta['_wc_memberships_profile_field_inductions']
    end
  end
end
