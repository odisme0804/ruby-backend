require 'rails_helper'
describe ApiV0::Users do
  headers = { "CONTENT_TYPE" => "application/json" }
  context 'POST /api/v0/users/login valid user' do
    it 'should return 200 and return token' do
      params = {
        email: "root@gmail.com",
        password: "root",
      }
      post '/api/v0/users/login', params: params.to_json, :headers => headers

      parsed_body = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(parsed_body["token"]).not_to be_nil
      expect(parsed_body["token"]).not_to eq("")
      expect(parsed_body["exp"]).to be > Time.now
    end
  end

  context 'POST /api/v0/users/login user not found' do
    it 'should return 401 and return token' do
      params = {
        email: "not_found@gmail.com",
        password: "root",
      }
      post '/api/v0/users/login', params: params.to_json, :headers => headers

      parsed_body = JSON.parse(response.body)
      expect(response.status).to eq(401)
      expect(parsed_body["error"]["message"]).to eq("Email not found or password not match")
    end
  end
end