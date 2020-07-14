module ApiV0
  module Entities
    class Paginator < Entities::Base
      expose :page
      expose :per_page
      expose :total_page
    end
  end
end
