defmodule HomeworkWeb.Schema.Query.CreateMerchantTest do
  use HomeworkWeb.ConnCase, async: true

  @query """
  mutation CreateMerchant($name: Name!, $description: Description!) {
    createMerchant(name: $name, description: $description) {
      name
      description
    }
  }
  """
  test "createMerchant field creates a merchant sucessfully" do
    conn = build_conn()

    conn =
      post(conn, "/graphiql",
        query: @query,
        variables: %{
          name: "Greater Wynnwood Exotic Animal Park",
          description: "Exotic Animal Zoo"
        }
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "createMerchant" => %{
                 "name" => "Greater Wynnwood Exotic Animal Park",
                 "description" => "Exotic Animal Zoo"
               }
             }
           }
  end

  @invalid_query """
  mutation CreateMerchant($description: Description!) {
    createMerchant(description: $description) {
      name
      description
    }
  }
  """
  test "createMerchant with not the required inputs will error" do
    conn = build_conn()

    conn =
      post(conn, "/graphiql",
        query: @invalid_query,
        variables: %{
          description: "Exotic Animal Zoo"
        }
      )

    assert json_response(conn, 200) == %{
             "errors" => [
               %{
                 "locations" => [%{"column" => 3, "line" => 2}],
                 "message" => "In argument \"name\": Expected type \"String!\", found null."
               }
             ]
           }
  end
end
