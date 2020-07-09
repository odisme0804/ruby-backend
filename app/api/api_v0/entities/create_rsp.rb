module ApiV0
  module Entities
    class CreateRsp < Entities::Base
      expose :location
      expose :created_at, format_with: :iso8601
    end
  end
end
