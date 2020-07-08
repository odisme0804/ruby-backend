module ApiV0
  module Entities
    class Course < Entities::Base
      expose :id
      expose :topic
      expose :description
      expose :price
      expose :currency
      expose :category
      expose :url
      expose :expiration
      expose :available, if: { type: :admin }
      expose :created_at
    end
  end
end
