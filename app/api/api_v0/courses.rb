# /courses
module ApiV0 
  class Courses < Grape::API
    resource :courses do
      desc "Get courses"
      params do
        optional :limit, type: Integer, values: ->(v) { v > 0 && v < 50 },  default: 10
        optional :offset, type: Integer, values: ->(v) { v >= 0},  default: 0
      end
      get "/" do
        admin_authenticate!
        coursesRsp = {
            courses: Course.limit(params[:limit]).offset(params[:offset]),
            paginator: {limit: params[:limit], offset: params[:offset], has_next: Course.count > params[:limit]*(params[:offset]+1)}
        }
        present coursesRsp, with: ApiV0::Entities::CoursesRsp, type: :admin
      end

      desc "Get course by id"
      params do
        requires :id, type: String, desc: 'Course ID'
      end
      get "/:id" do
        admin_authenticate!
        coursesRsp = {
            course: Course.find(params[:id])
        }
        present coursesRsp, with: ApiV0::Entities::CourseRsp, type: :admin
      end

      desc "Create new course"
      params do
        requires :topic, values: ->(v) { v.length <= 20 }, type: String, allow_blank: false
        requires :description, values: ->(v) { v.length <= 20 }, type: String, allow_blank: false
        requires :price, type: Float, values: ->(v) { v >= 0.0 }, allow_blank: false
        requires :currency, type: Symbol, values: [:NTD, :USD, :EUR], allow_blank: false
        requires :category, type: String, allow_blank: false
        requires :url, type: String, allow_blank: false
        requires :expiration, values: 86400..86400*30, type: Integer, allow_blank: false
        requires :available, type: Boolean, allow_blank: false
      end
      post "/" do
        admin_authenticate!
        course = Course.new(declared(params))
        if course.save
          createRsp = { location: "/api/v0/courses/"+course.id.to_s, created_at: course.created_at}
          present createRsp, with: ApiV0::Entities::CreateRsp
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
          status 204
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
          status 204
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
        
        # TODO: fix the style
        ret = []
        records.each do |obj|
            purchasedCourse = {
                id: obj.course.id,
                topic: obj.course.topic,
                description: obj.course.description,
                price: obj.course.price,
                currency: obj.course.currency,
                category: obj.course.category,
                url: obj.course.url,
                expiration: obj.course.expiration,
                pay_by: obj.pay_by,
                available: obj.course.available,
                created_at: obj.course.created_at,
            }
            ret.push(purchasedCourse)
        end
        present ret, with: ApiV0::Entities::PurchasedCourse
      end
    end
  end
end
