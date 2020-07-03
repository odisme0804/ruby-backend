module ApiV0
  class Courses < Grape::API
    desc "Get courses"
    get "/courses" do
      Course.all
    end

    desc "Get course by id"
    get "/courses/:id" do
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
    end
    post "/courses" do
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
    end
    put "/courses/:id" do
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
    delete "/courses/:id" do
      course = Course.find(params[:id])

      if course.destroy
        return course
      else
        raise StandardError, $!
      end
    end
  end
end
