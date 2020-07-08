# /courses
module ApiV0 
  class Courses < Grape::API
    resource :courses do
      desc "Get courses"
      get "/" do
        present Course.all, with: ApiV0::Entities::Course, type: :admin
      end

      desc "Get course by id"
      params do
        requires :id, type: String, desc: 'Course ID'
      end
      get "/:id" do
        present Course.find(params[:id]), with: ApiV0::Entities::Course, type: :admin
      end

      desc "Create new course"
      params do
        requires :topic, values: ->(v) { v.length <= 20 }, type: String, allow_blank: false
        requires :description, values: ->(v) { v.length <= 20 }, type: String, allow_blank: false
        requires :price, type: Float, allow_blank: false
        requires :currency, type: Symbol, values: [:NTD, :USD, :EUR], allow_blank: false
        requires :category, type: String,allow_blank: false
        requires :url, type: String, allow_blank: false
        requires :expiration, values: 86400..86400*30, type: Integer, allow_blank: false
        requires :available, type: Boolean, allow_blank: false
      end
      post "/" do
        admin_authenticate!
        course = Course.new(declared(params))
        if course.save
          return course
        else
          raise StandardError, $!
        end
      end

      desc "Update course"
      params do
        requires :id, type: String, allow_blank: false
        requires :topic, values: ->(v) { v.length <= 20 }, type: String, allow_blank: false
        requires :description, values: ->(v) { v.length <= 20 }, type: String, allow_blank: false
        requires :price, type: Float, allow_blank: false
        requires :currency, type: Symbol, values: [:NTD, :USD, :EUR], allow_blank: false
        requires :category, type: String,allow_blank: false
        requires :url, type: String, allow_blank: false
        requires :expiration, values: 86400..86400*30, type: Integer, allow_blank: false
        requires :available, type: Boolean, allow_blank: false
      end
      put "/:id" do
        admin_authenticate!
        course = Course.find(params[:id])
        if course.update(declared(params))
          return course
        else
          raise StandardError, $!
        end
      end

      desc "Delete a course"
      params do
        requires :id, type: String, desc: 'Course ID'
      end
      delete "/:id" do
        admin_authenticate!
        course = Course.find(params[:id])
        if course.destroy
          return course
        else
          raise StandardError, $!
        end
      end
    end # resource end
  end
end

# /user/courses
module ApiV0
  class Courses < Grape::API
    resource :user do
      get "/courses" do
        authenticate!
        unless current_user
          status 403
          return { error: 'forbidden' }
        end
        params do
          optional :available, type: Boolean
          optional :category, type: String
        end
        records = PurchaseRecord.joins(:course).includes(:course).where(user_id: current_user.id)
        if params[:category]
          records = records.where("courses.category = ?", params[:category])
        end
        if params[:available]
          records = records.where("expired_at >= ?", Time.now.utc)
        end

        present records.map { |obj| obj.course }, with: ApiV0::Entities::Course
      end
    end
  end
end

# /users/:id/courses
module ApiV0
  class Courses < Grape::API
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
        
        present records.map { |obj| obj.course }, with: ApiV0::Entities::Course, type: :admin
      end
    end
  end
end
