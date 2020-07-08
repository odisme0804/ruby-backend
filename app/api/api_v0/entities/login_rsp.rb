module ApiV0
  module Entities
    class LoginRsp < Entities::Base
      expose :token
      expose :exp, format_with: :iso8601
    end
  end
end
