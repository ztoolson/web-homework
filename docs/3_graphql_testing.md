# my thoughts on testing the resolvers and mutations

the project comes with tests for the homework context to test some of the business logic (validations). this is only one layer of the application. adding tests for the resolvers and mutations will be beneficial to know that our api layer is implemented the way that we want and is all wired up. these tests also protect us from changes in the lower level that might break the api.

## implementation notes

  - use ExUnit (same as existing tests) to add tests to the absinthe schema. this ensures our queries work now and will help prevent regressions.

## why did i choose ExUnit
  ExUnit is already being used in the project. this project is also a json api, not a full stack web application where we might want to test using a browser (looks like hound is the popular library of choice for elixir).

