module ApiV0
  class Base < Grape::API
    version 'v0', using: :path

    use ApiV0::Auth::Middleware

    helpers ApiV0::Helpers

    mount Ping
    mount Courses
    mount Users
  end
end
