module ApiV0
  class Users < Grape::API
    resource :users do
      desc "List users"
      get "/" do
        authenticate!
        unless current_user.admin
          status 403
          return{ error: 'forbidden' }
        end
        User.all
      end

      desc "Create new user"
      params do
        requires :email, type: String
        requires :password, type: String
        requires :admin, type: Boolean
      end
      post "/" do
        user = User.new(declared(params))
        if user.save
          return user
        else
          raise StandardError, $!
        end
      end

      desc "Login to get auth token"
      params do
        requires :email, type: String
        requires :password, type: String
      end
      post "/login" do
        user = User.find_by(email: params[:email]).try(:authenticate, params[:password])
        if user
          token = JsonWebToken.encode(id: user.id)
          detoken = JsonWebToken.decode(token)
          puts "detoken", detoken
          time = Time.now + 24.hours.to_i
          { token: token, exp: time.strftime("%Y-%m-%dT%H:%M:%S")}
        else
          status 401
          { error: 'unauthorized' }
        end
      end
    end # resource end
  end
end
