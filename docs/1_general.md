# my thoughts on implementing the backend objectives.
  NOTE: all of my notes are all lower case just to brain dump my thoughts.

  1. completed - write filtering options for transactions, users, and/or merchants
  2. write a new schema, queries, and mutations to add companies to the app
  3. completed - seed the database
  4. completed - write tests for the resolvers & mutations
  5. add a pagination layer to the queries
  6. completed - allow the mutations to handle a decimal amount for transactions (the database stores it as cents)

# general thoughts and improvements i would make to the api with more time
  - change the `credit` and `debit` fields from bool, to a combined enum field `transaction_type` that can be one of those.
  - change dob from string type to date type (api and database). add some contraints (i.e. dob cannot be in the future). using the string type gives no control over formatting (i mean i guess you could use a db contraint to enforce that but it would be better to use the accurate type)
  - handle noresultserror (i.e. attempting to update a user that doesn't exist) gracefully. currently the error is thrown and isn't converted to a nice error message in the graphql layer

# overall thoughts
  i have never actually worked with graphql before and it has been years since doing elixir / phoenix (back in my day we had to type the phoenix command, not phx). it was really fun to get up to speed on absinthe and creating a graphql api. i would love any feedback on best practices or divvy practices on the solutions to these problems and how they would differ to mine :) . 


# approaches to non completed items

## approach to adding companies to the app
  - create a new migration for companies with name and credit_limit in the companies table.
  - add company_id field to existing users table
  - add company_id field on the existing transactions table and require this to be passed in (this is per the spec. but i'm not sure if this is a good idea. this can be calculated through the users table. if we do this, we should have a constraint that when creating a transction, company_id must equal the user company_id that the transaction belongs to)
  - add requirements that users must have user_id passed in (similar to transactions with user_id and merchant_id
  - available_credit would be a calculated field. if we have company_id on the transaction then we can calculate where transaction.company_id = company.id if we don't attach transaction directly to the company: getting all the transactions for a given company could be found by joining company.id = user.company_id and get user_id's and then joining the user_id'sto transactions table u.id = transaction.user_id. then sum the transactions (subtract if debit and add for credit)
  - add company to schema and create resolvers. same default operations as other resources

## approach to pagination
  - the spec pagination can acutally cause problems: (example query: `select * from :table limit :limit offset :offset`
    a. when iterating over the table, if others are modifying the data then some data will be missed
    b offset gets expensive to calculate when the table gets large. the way offset is implemented in postgres is that it must scan through storage to count rows
  - recommended approach would be to use keyset pagination. limit is the same, skip is the last id from the previous set and the query would be `select * from :table where id > :last_id limit :limit.` this is much more efficient because we don't have to calcualte all the rows to then perform the offset
  - including the total count for pagination can be an expensive db operation with large amounts of data (seq scan on data to get the count). if we need the exact count, we can track inserts / deletes (either db trigger in another postgres table, or redis with a regular reconcile with the exact count to handle cases where this gets off)
  - as far as making it a wrapper, i would have to research how to do that. i'm not sure off the top of my head how to accomplish that.

# my general thoughts on approaching projects

i understand that the homework is lacking a lot of context that might influence decisions. it is fun to get to solve the objectives. here are my thoughts on executing on projects and making sure the team has all the context. this is something that my teams implemented at weave that was successful, but if divvy does things differently i'm 100% open to learning new ways.

recently, it has been useful to have a project lifecycle for consistency and tracking things. at a high level i think there are 4 steps that are useful. these are generally for larger proejcts where the requirements of this take home test might fit into a larger context.

  1. have a product requirement spec document written
    a. this should outline the business goals of the project. what does success look like. specify what is being delivered and what isn't going to be delivered. optionally break this up into stages of delivery
  2. after the product requirements are defined, perform some engineering planning
    a. do planning before something new. this could be getting together and whiteboarding or just talking through the approach
    b. write down the plan in a short document. define clear milestones of for delivery.
    c. share document for review and approval
  3. start executing on the project
  4. follow up and clean up after shipping

i'm going to try and follow a similar process to this (mostly step 2) for each of features requested just to share my thoughts as much as possible in the interview experience.
