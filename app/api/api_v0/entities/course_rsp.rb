module ApiV0
  module Entities
    class CourseRsp < Entities::Base
      expose :course, using: ApiV0::Entities::Course
    end
  end
end
