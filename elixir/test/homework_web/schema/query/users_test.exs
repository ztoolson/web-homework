defmodule HomeworkWeb.Schema.Query.UsersTest do
  use HomeworkWeb.ConnCase, async: true

  alias Homework.Repo
  alias Homework.Users.User
  alias Homework.Transactions.Transaction
  alias Homework.Merchants.Merchant

  setup do
    Repo.delete_all(Transaction)
    Repo.delete_all(User)
    users = [
      %User{
        dob: "1/1/1900",
        first_name: "zach",
        last_name: "toolson"
      },
      %User{
        dob: "3/15/1980",
        first_name: "michael",
        last_name: "scott"
      },
      %User{
        dob: "3/5/1963",
        first_name: "joseph allen",
        last_name: "schreibvogel"
      }
    ]

    Enum.each(users, fn user ->
      Repo.insert!(user)
    end)
  end

  @query """
  {
    users{
      dob
      first_name
      last_name
    }
  }
  """
  test "users field returns a list of users" do
    conn = build_conn()
    conn = get conn, "/graphiql", query: @query
    assert json_response(conn, 200) == %{
      "data" => %{
        "users" => [
          %{"dob" => "1/1/1900", "first_name" => "zach", "last_name" => "toolson"},
          %{"dob" => "3/15/1980", "first_name" => "michael", "last_name" => "scott"},
          %{"dob" => "3/5/1963", "first_name" => "joseph allen", "last_name" => "schreibvogel"},
        ]
      }
    }
  end
end
