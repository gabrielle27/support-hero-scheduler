# Support Hero Scheduler

Simple application to allow scheduling of on-duty support person.


## Dependencies

- Rails 4.2.4
- Ruby 2.0.0
- PostgreSQL 9.4

## Getting Started

```
git clone git@github.com:gabrielle27/support-hero-scheduler.git
cd support-hero-scheduler
bundle install
rake db:create && rake db:migrage && rake db:seed
rails s
````

visit localhost:3000

## Running Tests

### Setup

```
rake db:create RAILS_ENV=test && rake db:migrate RAILS_ENV=test
```

### Unit Tests

`rake test test/models/*`

### Functional Tests

`test/controllers/*`

### Integration Tests

`rake test test/integration/*`


## View Application

https://support-hero-scheduler.herokuapp.com/
