# my thoughts on the seeding
  adding the filtering options seems like a requirement for most api's. this is my first time working with graphql so it has been fun to figure this part out.

## implementation details
  - for fuzzy filtering, impelement using the simple `ilike` in the database. `ilike` is ok for textual data types but is lacking in a lot of ways. if we wanted more sophisticated search we can leverage postgres tsvector database type. then if there are some serious search requirements it might be worth exploring elasticsearch or lucene.

## future thoughts / needs
  - some other filters that would probably be useful is filtering transaction by user_id and filtering by merchant_id. i don't think this would be too hard to implement but i wanted to make sure i got enough done in a quick amount of time.
