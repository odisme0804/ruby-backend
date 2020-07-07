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
          records.map { |obj| obj.course }
      end
    end
  end
end

# /courses
module ApiV0 
  class Courses < Grape::API
    resource :courses do
      desc "Get courses"
      get "/" do
        Course.all
      end

      desc "Get course by id"
      params do
        requires :id, type: String, desc: 'Course ID'
      end
      get "/:id" do
        Course.find(params[:id])
      end

      desc "Create new course"
      params do
        requires :topic, values: ->(v) { v.length <= 20 }, type: String, allow_blank: false
        requires :description, values: ->(v) { v.length <= 20 }, type: String, allow_blank: false
        requires :price, type: Float, allow_blank: false
        requires :currency, type: String, values: [:NTD, :USD, :EUR], allow_blank: false
        requires :category, type: String,allow_blank: false
        requires :url, type: String, allow_blank: false
        requires :expiration, values: 86400..86400*30, type: Integer, allow_blank: false
        requires :available, type: Boolean, allow_blank: false
      end
      post "/" do
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
        requires :currency, type: String, values: [:NTD, :USD, :EUR], allow_blank: false
        requires :category, type: String,allow_blank: false
        requires :url, type: String, allow_blank: false
        requires :expiration, values: 86400..86400*30, type: Integer, allow_blank: false
        requires :available, type: Boolean, allow_blank: false
      end
      put "/:id" do
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
