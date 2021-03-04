defmodule HomeworkWeb.Schema.Query.UpdateUserTest do
  use HomeworkWeb.ConnCase, async: true

  alias Homework.Repo
  alias Homework.Users.User

  @query """
  mutation UpdateUser($id: ID!, $dob: Episode!, $first_name: FirstName!, $last_name: LastName!) {
    updateUser(id: $id, dob: $dob, first_name: $first_name, last_name: $last_name) {
      id
      dob
      first_name
      last_name
    }
  }

  """
  test "updateUser field updates a user" do
    user =
      Repo.insert!(%User{
        dob: "3/15/1963",
        first_name: "joseph allen",
        last_name: "schreibvogel"
      })

    conn = build_conn()

    conn =
      post(conn, "/graphiql",
        query: @query,
        variables: %{
          id: user.id,
          dob: "3/15/1963",
          first_name: "joe",
          last_name: "exotic"
        }
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "updateUser" => %{
                 "id" => user.id,
                 "dob" => "3/15/1963",
                 "first_name" => "joe",
                 "last_name" => "exotic"
               }
             }
           }
  end
end
