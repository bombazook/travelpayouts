# Travelpayouts test app

### 1. Build images
```bash
docker-compose up -d --build
```
Now we have puma running on 0.0.0.0:3000 and postgresql configured

### 2. Load db defaults
```bash
docker-compose exec api bundle exec rake db:create
docker-compose exec api bundle exec rake db:migrate
docker-compose exec api bundle exec rake db:seed
```
Now we have db default values all set

## Tasks
### 1. Create new user

#### using jsonapi
```bash
curl -0 -v -X POST http://localhost:3000/users \
-H "Accept: application/vnd.api+json"          \
-H "Content-Type: application/vnd.api+json"    \
-d @- <<'EOF'
{
  "data": {
    "type": "users",
    "attributes": {
      "email": "some@email.com",
      "name": "Test user 1"
    }
  }
}
EOF
```
#### using json
```bash
curl -0 -v -X POST http://localhost:3000/users \
-H "Accept: application/json"                  \
-H "Content-Type: application/json"            \
-d '{"user": {"email": "some@email.com", "name": "Test user 2"}}'
```

### 4. Get user info
```bash
curl -H "Accept: application/json" http://localhost:3000/users/1
```

### 5. Get programs list
```bash
curl -H "Accept: application/json" http://localhost:3000/programs
```
Bonus task (term filtering):
```bash
curl -H "Accept: application/json" http://localhost:3000/programs?term=Train
```

### 6. Create user subscription
You can do it 5 different ways

#### Using jsonapi

##### with programs nested url
```bash
curl -0 -v -X POST http://localhost:3000/programs/1/subscriptions \
-H "Accept: application/vnd.api+json"                             \
-H "Content-Type: application/vnd.api+json"                       \
-d @- <<'EOF'
{
  "data": {
    "type": "subscriptions",
    "relationships": {
      "user": {
        "data": {
          "type": "users",
          "id": "1"
        }
      }
    }
  }
}
EOF
```

##### with users nested url
```bash
curl -0 -v -X POST http://localhost:3000/users/1/subscriptions \
-H "Accept: application/vnd.api+json"                          \
-H "Content-Type: application/vnd.api+json"                    \
-d @- <<'EOF'
{
  "data": {
    "type": "subscriptions",
    "relationships": {
      "program": {
        "data": {
          "type": "programs",
          "id": "2"
        }
      }
    }
  }
}
EOF
```

##### with root subscriptions url
```bash
curl -0 -v -X POST http://localhost:3000/subscriptions \
-H "Accept: application/vnd.api+json"                  \
-H "Content-Type: application/vnd.api+json"            \
-d @- <<'EOF'
{
  "data": {
    "type": "subscriptions",
    "relationships": {
      "user": {
        "data": {
          "type": "users",
          "id": "1"
        }
      },
      "program": {
        "data": {
          "type": "programs",
          "id": "3"
        }
      }
    }
  }
}
EOF
```

#### Using json

##### with users nested url
```bash
curl -0 -v -X POST http://localhost:3000/users/1/subscriptions \
-H "Accept: application/json"                                  \
-H "Content-Type: application/json"                            \
-d '{"subscription": {"program_id": 4}}'
```

##### with programs nested url
```bash
curl -0 -v -X POST http://localhost:3000/programs/5/subscriptions \
-H "Accept: application/json"                                     \
-H "Content-Type: application/json"                               \
-d '{"subscription": {"user_id": 1}}'
```

Additionally you may set 'banned' attribute to true in every type of subscription creation.
Or update subscription with separate request:
```bash
curl -0 -v -X PATCH http://localhost:3000/subscriptions/1 \
-H "Accept: application/json"                             \
-H "Content-Type: application/json"                       \
-d '{"subscription": {"banned": true}}'
```
This will make program hidden in user's programs list:
```bash
curl -H "Accept: application/json" http://localhost:3000/users/1/programs
```

# Testing

If you want to run tests or use guard gem for automated testing run
```bash
docker-compose exec test bundle exec rake db:create
docker-compose exec test bundle exec rake db:migrate
```
after test container built and configured find out its id
```bash
docker container ls | grep travelpayouts_test
```
and run
```bash
docker attach <your test container id>
```

# Development or test debugging
1. Get your container id
```bash
docker container ls | grep travelpayouts_api
```
2. Insert your byebug breakpoint
3. run
```bash
docker attach <your api container id>
```
4. ... PROFIT
5. Press Ctrl+P then Ctrl+Q to detach after debugging is done
