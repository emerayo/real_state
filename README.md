# Real State

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
