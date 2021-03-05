# my thoughts on the seeding
  adding the filtering options seems like a requirement for most api's. this is my first time working with graphql so it has been fun to figure this part out.

## implementation details
  - for fuzzy filtering, impelement using the simple `ilike` in the database. `ilike` is ok for textual data types but is lacking in a lot of ways. if we wanted more sophisticated search we can leverage postgres tsvector database type. then if there are some serious search requirements it might be worth exploring elasticsearch or lucene.

## future thoughts / needs
  - some other filters that would probably be useful is filtering transaction by user_id and filtering by merchant_id. i don't think this would be too hard to implement but i wanted to make sure i got enough done in a quick amount of time.
  - we also probably want to audit the filtering fields and make sure that we have indexes on them for efficiency. we can use a gin index (or explore pg_trgm extension to use a trigram index) on the fuzzy searched fields to improve performance(note: might need a second index on the column if performance = instead of fuzzy searching but currently that doesn't apply). then for the transaction filtering field we can add a btree index for improved search performance.
