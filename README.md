# HW-Snapask

A simple content manager backend api server with RoR and Grape.


# Usage

### Start the server 
```bash
rails s
```

### Seed database if you need
```bash
rails db:fixtures:load
```

## Login
  You need to get the auth token first for the following apis
```bash
curl -X POST \
  http://localhost:3000/api/v0/users/login \
  -H 'content-type: application/json' \
  -d '{"email":"root@snapask.com","password":"root"}
'
```
and you'll get the response like below
```javascript
{
  "token":"...eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MTM1MTM4NjgwLCJl...",
  "exp":"2006-01-02T15:04:05Z"
}
```
Please put the token in the `Authorization` header.  
This Token will be expired in 1 day.


## Admin Only APIs
### Course
Create
```bash
curl -X POST \
  http://localhost:3000/api/v0/courses \
  -H 'authorization: your-token' \
  -H 'content-type: application/json' \
  -d '{
  	"topic":"course_topic", 
  	"description":"course_description",
  	"price":0.0,
  	"currency":"NTD",
  	"category":"computer_science",
  	"url":"https://course.com",
  	"expiration":86400, 
  	"available": "true"
  }
'
```
the constrain of each parameter please check:
/app/api/api_v0/courses.rb#20

Update
```bash
curl -X PUT \
  http://localhost:3000/api/v0/courses/<course_id> \
  -H 'authorization: your-token' \
  -H 'content-type: application/json' \
  -d '{
  	"topic":"course_topic", 
  	"description":"course_description",
  	"price":0.0,
  	"currency":"NTD",
  	"category":"computer_science",
  	"url":"https://course.com",
  	"expiration":86400, 
  	"available": "true"
  }
'
```
the constrain of each parameter please check:
/app/api/api_v0/courses.rb#41

Delete
```bash
curl -X DELETE \
  http://localhost:3000/api/v0/courses/<course_id> \
  -H 'authorization: your-token' \
  -H 'content-type: application/json'
```

Get
```bash
curl -X GET \
  http://localhost:3000/api/v0/courses/<course_id> \
  -H 'authorization: your-token' \
  -H 'content-type: application/json'
```

List
```bash
curl -X GET \
  http://localhost:3000/api/v0/courses \
  -H 'authorization: your-token' \
  -H 'content-type: application/json'
```