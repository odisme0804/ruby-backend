module ApiV0
  module Entities
    class PurchasedCourse < Entities::Base
      expose :id
      expose :course_id
      expose :topic
      expose :description
      expose :price
      expose :currency
      expose :category
      expose :url
      expose :expiration
      expose :available, if: { type: :admin }
      expose :created_at
      expose :pay_by
    end
  end
end
  