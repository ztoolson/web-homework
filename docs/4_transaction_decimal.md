# my thoughts on handling decimal amount for transactions
  this seems like it will make it more obvious to the consumer of the api. this will allow all consumption of the api to be in the decimal form (I.E 20.48 is 20 dollars and 48 cents) while internally we can treat all amounts as cents (2048) so that we don't have to worry about floating point percision problems when it comes to money.

##  implementation notes
  - create a custom graphql type to handle the conversion between the api layer and our internal library.
  - the api will accept amount in the form of a decimal (20.48) or string ("20.48) but will output in the result in the form of the string to preserve 2 decimal points ("101.00" instead of 101.0). if we wanted to change this, we could update our custom scalar type serialize to not format to string.

## thoughts 
  - currently the amount doesn't specify the currency type (I.E. USD or CAD or euro's). In the future we probably want our API to have 2 fields, one for amount and one for the currency type.
  - this is also a breaking change to the way amount functions in the existing API. if this was in production, this would break all of the clients current implementation where the field is in cents. this is my first time working with a graphql api but i would make sure to have a clean upgrade path. in other api's i've worked with, this could be deprecating the old field, introducing new field, then removing the old field. this could also be done using api versioning where a new version of the api is introduced.

