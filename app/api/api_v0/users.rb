# /users
module ApiV0
  class Users < Grape::API
    resource :users do
      desc "List users"
      get "/" do
        admin_authenticate!
        User.all
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
          return user
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
          time = Time.now + 24.hours.to_i
          { token: token, exp: time.strftime("%Y-%m-%dT%H:%M:%S")}
        else
          raise LoginAuthorizationError
        end
      end
    end # resource end
  end
end

# /users/:id/courses
module ApiV0
  class Users < Grape::API
    resource :users do
      get ":id/courses" do
        admin_authenticate!
        params do
          optional :available, type: Boolean
          optional :category, type: String
        end
        records = PurchaseRecord.joins(:course).includes(:course).where(user_id: params[:id])
        if params[:category]
          records = records.where("courses.category = ?", params[:category])
        end
        if params[:available]
          records = records.where("expired_at >= ?", Time.now.utc)
        end
        records.map { |obj| obj.course }
      end
    end
  end
end