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
  "token":"...your-token...",
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
#### parameters:
`topic`: string, must in the range of 1~20 words  
`description`: string,  must in the range of 1~20 words  
`price`: float, must greater than or equal to 0  
`currency`: enum, currently only support NTD, USD or EUR  
`category`: string, can't be blank  
`url`: url, can't be blank  
`expiration`: int, the course available window in secound after purchasing, must in the range of 86400 to 86400*30  
`available`: boolean, the course is available or not

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
#### parameters: 
same as Create api

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

## General APIs
### Get purchased records
```bash
curl -X GET \
  http://localhost:3000/api/v0/user/courses \
  -H 'authorization: your-token'
```
#### query parameters:
`available`: true/false, true to show the courses which are still available for current user 
`category`: string, filter by the specific category name

### Purchase a course
```bash
curl -X POST \
  http://localhost:3000/api/v0/user/purchase-courses/<course_id> \
  -H 'authorization: your-token' \
  -H 'content-type: application/json' \
  -d '{"pay_by": "the_way_you_pay_the_bill"}'
```
