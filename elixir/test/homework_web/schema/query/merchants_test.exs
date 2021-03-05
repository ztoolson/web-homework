defmodule HomeworkWeb.Schema.Query.MerchantsTest do
  use HomeworkWeb.ConnCase, async: true

  alias Homework.Repo
  alias Homework.Transactions.Transaction
  alias Homework.Merchants.Merchant

  setup do
    Repo.delete_all(Transaction)
    Repo.delete_all(Merchant)

    merchants = [
      %Merchant{
        description: "Exotic Animal Zoo",
        name: "Greater Wynnewood Exotic Animal Park"
      },
      %Merchant{
        description: "The finest paper products",
        name: "Dunder Mifflin"
      }
    ]

    Enum.each(merchants, fn merchant ->
      Repo.insert!(merchant)
    end)
  end

  @query """
  {
    merchants{
      description
      name
    }
  }
  """
  test "merchants field returns a list of merchants" do
    conn = build_conn()
    conn = get(conn, "/graphiql", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "merchants" => [
                 %{
                   "description" => "Exotic Animal Zoo",
                   "name" => "Greater Wynnewood Exotic Animal Park"
                 },
                 %{"description" => "The finest paper products", "name" => "Dunder Mifflin"}
               ]
             }
           }
  end

  @filter_query """
  {
    merchants(name: "exotic"){
      description
      name
    }
  }
  """
  test "merchants field returns a filtered list of merchants" do
    conn = build_conn()
    conn = get(conn, "/graphiql", query: @filter_query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "merchants" => [
                 %{"description" => "Exotic Animal Zoo", "name" => "Greater Wynnewood Exotic Animal Park"}
               ]
             }
           }
  end
end
