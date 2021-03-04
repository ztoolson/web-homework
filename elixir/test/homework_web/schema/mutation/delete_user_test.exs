defmodule HomeworkWeb.Schema.Query.DeleteUserTest do
  use HomeworkWeb.ConnCase, async: true

  alias Homework.Repo
  alias Homework.Users.User

  @query """
  mutation DeleteUser($id: ID!) {
    deleteUser(id: $id) {
      id
      dob
      first_name
      last_name
    }
  }

  """
  test "deleteUser field deletes a user" do
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
          id: user.id
        }
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "deleteUser" => %{
                 "id" => user.id,
                 "dob" => "3/15/1963",
                 "first_name" => "joseph allen",
                 "last_name" => "schreibvogel"
               }
             }
           }
  end
end
