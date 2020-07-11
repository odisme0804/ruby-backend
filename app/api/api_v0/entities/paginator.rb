module ApiV0
  module Entities
    class Paginator < Entities::Base
      expose :limit
      expose :offset
      expose :has_next
    end
  end
end
