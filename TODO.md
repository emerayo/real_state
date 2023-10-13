# TODO

## Authentication

- Add an admin class to the system (using Devise)
- Add Authentication
- Add Authorization, so only admins can manage data (using CanCanCan)

## Data modeling

- Extract Property's location to a separate model (address) with split fields (address1, address2, city, state, county, zipcode)
- Add address to Agent
- Associate a Property without Agent, considering it's close to the Agent's address
- Add audit gem, to track changes to Property's fields

## API

- Write Swagger documentation file
- Add Authentication
- Add Authorization

## Tests

- Add FactoryBot
