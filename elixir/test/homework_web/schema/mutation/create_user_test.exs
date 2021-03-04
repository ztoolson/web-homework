defmodule HomeworkWeb.Schema.Query.CreateUserTest do
  use HomeworkWeb.ConnCase, async: true

  @query """
  mutation CreateUser($dob: DOB!, $first_name: FirstName!, $last_name: LastName!) {
    createUser(dob: $dob, first_name: $first_name, last_name: $last_name) {
      dob
      first_name
      last_name
    }
  }

  """
  test "createUser field creates a user sucessfully " do
    conn = build_conn()

    conn =
      post(conn, "/graphiql",
        query: @query,
        variables: %{
          dob: "3/15/1980",
          first_name: "michael",
          last_name: "scott"
        }
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "createUser" => %{
                 "dob" => "3/15/1980",
                 "first_name" => "michael",
                 "last_name" => "scott"
               }
             }
           }
  end

  @invalid_query """
  mutation CreateUser($first_name: FirstName!, $last_name: LastName!) {
    createUser(first_name: $first_name, last_name: $last_name) {
      dob
      first_name
      last_name
    }
  }
  """
  test "createUser with not the required inputs will error" do
    conn = build_conn()

    conn =
      post(conn, "/graphiql",
        query: @invalid_query,
        variables: %{
          first_name: "michael",
          last_name: "scott"
        }
      )

    assert json_response(conn, 200) == %{
             "errors" => [
               %{
                 "locations" => [%{"column" => 3, "line" => 2}],
                 "message" => "In argument \"dob\": Expected type \"String!\", found null."
               }
             ]
           }
  end
end
