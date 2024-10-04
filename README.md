### Versions
Ruby 3.3.5

Rails 7.2.1

### Preparation
The application uses sqlite for demonstration purposes.

1. **Seed database**

   Run
   ```sh
   rails db:setup
   ```

### Tests & Console
Tests can be run by
```sh
rspec spec
```

For console access type
```sh
rails c
```

### Running server
Start server by
```sh
rails s
```
After initialization the app will be available at port 3000.
The app is API only app consuming and distributing data in json format.

### Authentication
To interact with the app, you must first obtain an authentication token. Follow these steps to get your token:
1. **Send a POST Request**: Make a POST request to the following endpoint:
`http://localhost:3000/api/v1/login`

2. **Request Body**: Include the following JSON body in your request. If you have seeded the database with default users, use the example credentials below:

```json
{
    "email": "customer1@example.com",
    "password": "password123"
}
```
3. **Response**: If the login is successful, you will receive a response containing your JWT token:

```json
{
    "token": "eyJhbGciOiJIUzI1NiJ9........"
}
```

4. **Using the token**: To access protected endpoints, include the token in the `Authorization` header of your requests in the following format:

`Authorization: Bearer {token}`

Make sure to replace `{token}` with the actual token you received in the response.

## Endpoints
The body of POST requests needs to be of type json:
```
  Content-Type: application/json
```

All monetary values are stored and presented as fractional values (in cents), e.g. 100.00 is stored as 10000.

### Customer
#### GET /api/v1/customers/current
Returning information about current customer

Response example:
```json
{
    "id": 2,
    "name": "Mary",
    "email": "mary@example.com",
}
```

### Session
#### POST /api/v1/login
Returning authentication token

Request example:
```json
{
    "email": "mary@example.com",
    "password": "password123"
}
```

Response example:
```json
{
    "token": "eyJhbGciOiJIUzI1NiJ9........"
}
```

### IE Statements
#### GET /api/v1/ie_statements
Returns IE Statements for logged in customer

Response example:
```json
[
    {
        "id": 1,
        "name": "Statement1",
        "created_at": "2024-10-04 11:14:49"
    },
    {
        "id": 2,
        "name": "Budget23",
        "created_at": "2024-10-04 11:25:44"
    }
]
```

#### GET /api/v1/ie_statements/:id
Returns pecific IE Statements for a customer

Response example:
```json
{
    "id": 2,
    "name": "Budget23",
    "created_at": "2024-10-04T11:25:44.856Z",
    "updated_at": "2024-10-04T11:25:44.856Z",
    "customer": {
        "id": 1
    },
    "incomes": [
        {
            "id": 3,
            "category": "Salary",
            "amount": 300000
        }
    ],
    "expenditures": [
        {
            "id": 6,
            "category": "Rent",
            "amount": 100000
        },
        {
            "id": 7,
            "category": "Travel",
            "amount": 15000
        }
    ]
}
```

#### POST /api/v1/customers/:customer_id/ie_statements
Creates new statement for `customer_id`. You can only create statements for your logged in `id`. 
The reason for this route is to allow in the future to create statements for different customers by admins or internal staff.

You can create statement alone and add incomes and expenditures later:
```json
{
    "ie_statement": {
        "name": "New budget"
    }
}
```

or create statement with incomes and expenditures in a one step:

```json
{
    "ie_statement": {
        "name": "Budget 9",
        "incomes_attributes": [
            {
                "category": "Salary",
                "amount": 300000
            }
        ],
        "expenditures_attributes": [
            {
                "category": "Rent",
                "amount": 100000
            },
            {
                "category": "Travel",
                "amount": "15000"
            }
        ]
    }
}
```

Response example:
```json
{
    "id": 6,
    "name": "Statement",
    "created_at": "2024-10-04T11:41:48.712Z",
    "updated_at": "2024-10-04T11:41:48.712Z",
    "customer": {
        "id": 2
    },
    "incomes": [
        {
            "id": 5,
            "category": "Salary",
            "amount": 300000
        }
    ],
    "expenditures": [
        {
            "id": 8,
            "category": "Rent",
            "amount": 100000
        },
        {
            "id": 9,
            "category": "Travel",
            "amount": 15000
        }
    ]
}
```
