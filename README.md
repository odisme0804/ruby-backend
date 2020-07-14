# Content Manager Backend With RoR

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
There are 3 accounts:
\ | email | password | is_admin
--- | --- | --- | ---
root | root@gmail.com | root | true
user1 | user1@gmail.com | user | false
user2 | user2@gmail.com | user | false

## Login
  You need to get the auth token first for the following apis
```bash
curl -X POST \
  http://localhost:3000/api/v0/users/login \
  -H 'content-type: application/json' \
  -d '{"email":"root@gmail.com","password":"root"}
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
return value
```javascript
{
  "location": "/api/v0/courses/<course_id>",
  "created_at": "2006-01-02T15:04:05Z"
}
```

#### parameters:
"topic": `string`, must in the range of 1 to 20 words.  
"description": `string`,  must in the range of 1 to 20 words.  
"price": `float`, must greater than or equal to 0.  
"currency": `enum`, currently only support `NTD`, `USD` or `EUR`.  
"category": `string`, can't be blank.  
"url": `url`, can't be blank.  
"expiration": `int`, the course available window in secound after purchasing, must in the range of 86400 to 86400*30.  
"available": `boolean`, the course is available or not.

#
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

#
Delete
```bash
curl -X DELETE \
  http://localhost:3000/api/v0/courses/<course_id> \
  -H 'authorization: your-token' \
  -H 'content-type: application/json'
```

#
Get
```bash
curl -X GET \
  http://localhost:3000/api/v0/courses/<course_id> \
  -H 'authorization: your-token' \
  -H 'content-type: application/json'
```

return value
```javascript
{
    "course": {
        "id": 207281424,
        "topic": "ruby",
        "description": "ruby tutorial",
        "price": 100,
        "currency": "NTD",
        "category": "computer_science",
        "url": "https://course_url.com.tw/ruby",
        "expiration": 86400,
        "available": true,
        "created_at": "2020-07-11T08:44:19.991Z"
    }
}
```

#
List
```bash
curl -X GET \
  http://localhost:3000/api/v0/courses \
  -H 'authorization: your-token' \
  -H 'content-type: application/json'
```
#### query parameters:
"page": `int`, for paging, can't be negative, default 1.  
"per_page": `int`, for paging, must between 1 to 50, default 10.  

#### return value:
```javascript
{
    "courses": [
        {
            "id": 207281424,
            "topic": "ruby",
            "description": "ruby tutorial",
            "price": 100,
            "currency": "NTD",
            "category": "computer_science",
            "url": "https://course_url.com.tw/ruby",
            "expiration": 86400,
            "available": true,
            "created_at": "2020-07-11T08:44:19.991Z"
        },
        ...
    ],
    // paging info
    "paginator": {
        "page": 1,
        "per_page": 3,
        "total_page": 2
    }
}
```

## General APIs
### Get purchased records
```bash
curl -X GET \
  http://localhost:3000/api/v0/user/courses \
  -H 'authorization: your-token'
```
#### query parameters:
"available": `boolean`, true to show the courses which are still available for current user.  
"category": `string`, filter by the specific category name.  
"page": `int`, for paging, can't be negative, default 1.  
"per_page": `int`, for paging, must between 1 to 50, default 10.  

#### return value:
```javascript
{
    "purchased_courses": [
        {
            "id": 238762669,
            "course_id": 207281424,
            "topic": "ruby",
            "description": "ruby tutorial",
            "price": 100,
            "currency": "NTD",
            "category": "computer_science",
            "url": "https://course_url.com.tw/ruby",
            "expiration": 86400,
            "created_at": "2020-07-11T08:44:19.991Z",
            "pay_by": "ibon"
        },
        ...
    ],
    // paging info
    "paginator": {
        "page": 1,
        "per_page": 3,
        "total_page": 2
    }
}
```

### Purchase a course
```bash
curl -X POST \
  http://localhost:3000/api/v0/user/purchase-courses/<course_id> \
  -H 'authorization: your-token' \
  -H 'content-type: application/json' \
  -d '{"pay_by": "<the_way_you_pay_the_bill>"}'
```
#### parameters:
"pay_by": `enum`, currently only support `ibon`, `visa`, `apple_pay`, and `free`.  

# For Development
## There are 3 addition api for user resource
### User
List
```bash
curl -X GET \
  http://localhost:3000/api/v0/users
```

#
Create
```bash
curl -X POST \
  http://localhost:3000/api/v0/users/ \
  -H 'content-type: application/json' \
  -d '{"email":"email","password":"root", "admin":"true"}'
```
#### parameters:
"email": `string`, email address as user id.  
"password": `string`, user password.   
"admin": `boolean`, this user is admin or not.

#
Update
```bash
curl -X PUT \
  http://localhost:3000/api/v0/users/<user_id> \
  -H 'content-type: application/json' \
  -d '{"email":"email","password":"root", "admin":"true"}'
```
#### parameters: 
same as Create api