module ApiV0
  module Entities
    class CoursesRsp < Entities::Base
      expose :courses, using: ApiV0::Entities::Course
      expose :paginator, using: ApiV0::Entities::Paginator
    end
  end
end
