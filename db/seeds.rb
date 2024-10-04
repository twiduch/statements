customer = Customer.create(name: 'Luke', email: 'luke@example.com', password: 'password123')
Customer.create(name: 'Mary', email: 'mary@example.com', password: 'password123')

statement = IeStatement.create(name: 'Statement1', customer:)

statement.incomes.create([ { category: 'Salary', amount: 280000 },
                           { category: 'Other', amount: 30000 } ])

statement.expenditures.create([ { category: 'Mortgage', amount: 50000 },
                                 { category: 'Utilities', amount: 10000 },
                                 { category: 'Travel', amount: 15000 },
                                 { category: 'Food', amount: 50000 },
                                 { category: 'Loan Repayment', amount: 100000 } ])
