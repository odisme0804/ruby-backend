module ApiV0
  class Courses < Grape::API
    resource :courses do
      desc "Get courses"
      get "/" do
        Course.all
      end

      desc "Get course by id"
      get "/:id" do
        Course.find(params[:id])
      end

      desc "Create new course"
      params do
        requires :topic, type: String
        requires :description, type: String
        requires :price, type: Float
        requires :currency, type: String
        requires :category, type: String
        requires :url, type: String
        requires :expiration, type: Integer
        requires :available, type: Boolean
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
        requires :id, type: String, desc: 'Course ID'
        requires :topic, type: String
        requires :description, type: String
        requires :price, type: Float
        requires :currency, type: String
        requires :category, type: String
        requires :url, type: String
        requires :expiration, type: Integer
        requires :available, type: Boolean
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
    end
  end
end
