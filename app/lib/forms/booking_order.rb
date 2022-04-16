module Forms
  class BookingOrder
    include ActiveModel::Model

    attr_accessor :email, :user

    validates :email, presence: true, unless: :user
  end
end
