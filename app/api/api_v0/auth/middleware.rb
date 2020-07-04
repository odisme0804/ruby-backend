module ApiV0
  module Auth
    class Middleware < Grape::Middleware::Base
      def before
        @env["api_v0.user"] ||= Authenticator.new(request).authenticate!
      end

      def request
        @request ||= ::Grape::Request.new(env)
      end
    end
  end
end
