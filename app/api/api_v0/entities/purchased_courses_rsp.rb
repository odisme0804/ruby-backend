module ApiV0
  module Entities
    class PurchasedCoursesRsp < Entities::Base
      expose :purchased_courses, using: ApiV0::Entities::PurchasedCourse
      expose :paginator, using: ApiV0::Entities::Paginator
    end
  end
end
