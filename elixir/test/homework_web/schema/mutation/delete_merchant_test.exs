defmodule HomeworkWeb.Schema.Query.DeleteMerchantTest do
  use HomeworkWeb.ConnCase, async: true

  alias Homework.Repo
  alias Homework.Merchants.Merchant

  @query """
  mutation DeleteMerchant($id: ID!) {
    deleteMerchant(id: $id) {
      id
      name
      description
    }
  }

  """
  test "deleteMerchant field deletes a merchant" do
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
          id: merchant.id
        }
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "deleteMerchant" => %{
                 "id" => merchant.id,
                 "name" => "Greater Wynnewood Exotic Animal Park",
                 "description" => "Exotic Animal Zoo"
               }
             }
           }
  end
end
