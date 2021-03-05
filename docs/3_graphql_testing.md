# my thoughts on testing the resolvers and mutations

  the project comes with tests for the homework context to test some of the business logic (validations). this is only one layer of the application. adding tests for the resolvers and mutations will be beneficial to know that our api layer is implemented the way that we want and is all wired up. these tests also protect us from changes in the lower level that might break the api. the other advantage of testing is to provide executable documentation on how the api can be used. 

## implementation notes

  - use ExUnit (same as existing tests) to add tests to the absinthe schema. this ensures our queries work now and will help prevent regressions.
  - implemented happy path tests. i added a commented out test for an error case (attempt to update a user that doesn't exist). the application doesn't handle it gracefully current,  so because of time, i added a TODO to come back to this.
  - ehancements could include more error testing. if there were more robust validations (I.E. verify that dob on a user is not in the future or needs a specific format) that the error messages in the response are accurate.
  - other enhancements to the tests could be: when deleting a user, verify the expected behavior for transactions (do nothing)

## why did i choose ExUnit
  ExUnit is already being used in the project. this project is also a json api, not a full stack web application where we might want to test using a browser (looks like hound is the popular library of choice for elixir).

## other notes
  - i'm not 100% sure on elixir best practices on folder structure / where to place the tests. how does divvy structure their tests?
