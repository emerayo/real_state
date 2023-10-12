# Real State

## System dependencies

* PostgreSQL 14.0+
* Ruby 3.2.1

## Setup

Copy the `sample.env` file:

```
$ cp sample.env .env
```

Now open `.env` file and make sure database environment variables are correct for your environment (use your Postgres configuration).

Install all gems and create the development and test databases:

```
$ bundle install
$ bin/rails db:setup
```

## Running the server

To run the server locally, run the command:

```
$ rails s
```

You can stop the server by pressing:

```
CTRL + C
```

## Running the tests

```
$ bundle exec rspec
```

### Checking code coverage for the project

After running `rspec`, it will generate a file in `coverage/index.html` containing the test results,
simply open it on a browser to check the coverage.

## Committing

This project uses [Overcommit](https://github.com/sds/overcommit), a gem that run some checks before allowing you to commit your changes.
Such as RuboCop, TrailingWhitespace and Brakeman.

Install Overcommit hooks:

```
$ overcommit --sign
$ overcommit --install
```

Now you can commit.
