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
