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
    "email": "luke@example.com",
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

### IE Statements
#### GET /api/v1/ie_statements
Returns IE Statements for logged customer

Response example:
```json
[
    {
        "id": 1,
        "name": "Statement1"
    },
    {
        "id": 2,
        "name": "Budget23"
    }
]
```

#### GET /api/v1/ie_statements/:id
Returns IE Statement for logged customer

Response example:
```json
{
    "id": 2,
    "name": "Budget23",
    "disposable_income": 395000,
    "rating": "B",
    "customer": {
        "id": 1
    },
    "incomes": [
        {
            "id": 3,
            "category": "Salary",
            "amount": 300000
        },
        {
            "id": 8,
            "category": "New income",
            "amount": 200000
        },
        {
            "id": 9,
            "category": "Next",
            "amount": 10000
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
Creates new statement for `customer_id`.
Currently, users can only create statements for themselves. This restriction ensures that customers can only manage their own data. 
However, this route has been designed to accommodate future functionality where admins or internal staff may create statements on behalf of other customers.

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
        "name": "Statement",
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
                "amount": 45000
            }
        ]
    }
}
```

Response example:
```json
{
    "id": 15,
    "name": "Statement",
    "disposable_income": 155000,
    "rating": "C",
    "customer": {
        "id": 1
    },
    "incomes": [
        {
            "id": 19,
            "category": "Salary",
            "amount": 300000
        }
    ],
    "expenditures": [
        {
            "id": 23,
            "category": "Rent",
            "amount": 100000
        },
        {
            "id": 24,
            "category": "Travel",
            "amount": 45000
        }
    ]
}
```

### Incomes
#### GET /api/v1/incomes/:id
Returns Income for logged customer

Response example:
```json
{
    "id": 2,
    "category": "Other",
    "amount": 30000
}
```

#### POST /api/v1/ie_statements/:ie_statement_id/incomes
Creates an income entry for an IE Statement. Customers are only permitted to add income to statements that belong to them.
This initiates the recalculation of the IE Statement's aggregate values.

Request example:
```json
{
    "income": {
        "category": "Remittance",
        "amount": 1200000
    }
}
```

Response example:
```json
{
    "id": 20,
    "category": "Remittance",
    "amount": 1200000,
}
```

### Expenditures
#### GET /api/v1/expenditures/:id
Returns Expenditure for logged customer

Response example:
```json
{
    "id": 3,
    "category": "Travel",
    "amount": 15000
}
```

#### POST /api/v1/ie_statements/:ie_statement_id/expenditures
Creates an expenditure entry for an IE Statement. Customers are only permitted to add income to statements that belong to them.
This initiates the recalculation of the IE Statement's aggregate values

Request example:
```json
{
    "expenditure": {
        "category": "Expenditure",
        "amount": 42000
    }
}
```

Response example:
```json
{
    "id": 22,
    "category": "Expenditure",
    "amount": 42000
}
```

## Extending the App

App can be extended adding features such as:

1. Removing/Updating income/expenditure
2. Making rating system more flexible with different bands
3. Add support for different currencies
4. Adding expenses and income categories
5. Automatic notifications after statement update

## App Refinements

The app needs further refinement in various aspects to ensure readiness for production.
Examples:

- **Security:** Implement account creation. Role based authorization.
- **Logging:** Add comprehensive logging for monitoring and debugging.
- **Monitoring:** Integrate tools to track performance and health.
- **Error Handling:** Improve handling and messaging for errors.

This initial version serves as a foundation for what can be further developed and polished.
