module ApiV0
  class Users < Grape::API
    resource :users do
      desc "List users"
      get "/" do
        admin_authenticate!
        present User.all, with: ApiV0::Entities::Course, type: :admin
      end

      desc "Create new user"
      params do
        requires :email, type: String
        requires :password, type: String
        requires :admin, type: Boolean
      end
      post "/" do
        admin_authenticate!
        user = User.new(declared(params))
        if user.save
          present user, with: ApiV0::Entities::Course, type: :admin
        else
          raise StandardError, $!
        end
      end

      desc "Update user"
      params do
        requires :id, type: String, desc: 'User ID'
        requires :email, type: String
        requires :password, type: String
        requires :admin, type: Boolean
      end
      put "/:id" do
        user = User.find(params[:id])
        if user.update(declared(params))
          present user, with: ApiV0::Entities::Course, type: :admin
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
          loginRsp = { token: token, exp: 24.hours.from_now}
          present loginRsp, with: ApiV0::Entities::LoginRsp
        else
          raise LoginAuthorizationError
        end
      end
    end # resource end
  end
end
