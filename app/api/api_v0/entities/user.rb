module ApiV0
  module Entities
    class User < Entities::Base
      expose :id
      expose :email
      expose :admin, if: { type: :admin }
      expose :created_at, format_with: :iso8601
      expose :updated_at, format_with: :iso8601, if: { type: :admin }
    end
  end
end
