module ApiV0
  module Auth
    class Authenticator
      def initialize(request)
        @request = request
      end

      def authenticate!
        token
      end

      def token
        header = @request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          decoded = JsonWebToken.decode(header)
          @current_user = User.find(decoded[:id])
        rescue ActiveRecord::RecordNotFound => e
          puts e
          return nil
        rescue JWT::DecodeError => e
          puts e
          return nil
        end
        @current_user
      end
    end
  end
end
