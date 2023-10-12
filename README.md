# Real State

## System dependencies

* PostgreSQL 14.0+
* Redis 6+
* Ruby 3.2.1

## Setup

Copy the `sample.env` file:

```shell
$ cp sample.env .env
```

Now open `.env` file and make sure database environment variables are correct for your environment (use your Postgres configuration).

Install all gems and create the development and test databases:

```shell
$ bundle install
$ bin/rails db:setup
```

## Running the server

To run the server locally, run the command:

```shell
$ rails s
```

You can stop the server by pressing:

```
CTRL + C
```

## Running the tests

```shell
$ bundle exec rspec
```

### Checking code coverage for the project

After running `rspec`, it will generate a file in `coverage/index.html` containing the test results,
simply open it on a browser to check the coverage.

## Committing

This project uses [Overcommit](https://github.com/sds/overcommit), a gem that run some checks before allowing you to commit your changes.
Such as RuboCop, TrailingWhitespace and Brakeman.

Install Overcommit hooks:

```shell
$ overcommit --sign
$ overcommit --install
```

Now you can commit.

## Troubleshooting

This project is using Redis as caching, if you believe your caching is not working properly, follow this steps to ensure it's working:

```shell
$ rails c
```

Now, test if Rails is caching the values correctly:
```ruby
> Rails.cache.write("test-key", 123)
=> true
> Rails.cache.read("test-key")
=> 123
```

If the response from `Rails.cache.read("test-key")` is `nil`, it means that your cache is not working.

To fix it, run this command:

```shell
$ rails dev:cache
```

You should see the message:
```
Development mode is now being cached.
```