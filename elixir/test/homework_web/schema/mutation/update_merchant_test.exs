defmodule HomeworkWeb.Schema.Query.UpdateMerchantTest do
  use HomeworkWeb.ConnCase, async: true

  alias Homework.Repo
  alias Homework.Merchants.Merchant

  @query """
  mutation Update($id: ID!, $name: Name!, $description: Description!) {
    updateMerchant(id: $id, name: $name, description: $description) {
      id
      name
      description
    }
  }
  """
  test "updateMerchant field updates a merchant successfully" do
    merchant =
      Repo.insert!(%Merchant{
        description: "Exotic Animal Zoo",
        name: "Greater Wynnewood Exotic Animal Park"
      })

    conn = build_conn()

    conn =
      post(conn, "/graphiql",
        query: @query,
        variables: %{
          id: merchant.id,
          name: "G.W. Zoo",
          description: merchant.description
        }
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "updateMerchant" => %{
                 "id" => merchant.id,
                 "name" => "G.W. Zoo",
                 "description" => "Exotic Animal Zoo"
               }
             }
           }
  end
end
