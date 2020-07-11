module ApiV0
  module Entities
    class PurchasedCourse < Entities::Course
      expose :pay_by
    end
  end
end
  