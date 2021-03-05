defmodule HomeworkWeb.Schema.Query.DeleteTransactionTest do
  use HomeworkWeb.ConnCase, async: true

  alias Homework.Repo
  alias Homework.Merchants.Merchant
  alias Homework.Transactions.Transaction
  alias Homework.Users.User

  @query """
  mutation DeleteTransaction($id: ID!) {
    deleteTransaction(id: $id) {
      id
      user_id
      merchant_id
      amount
      credit
      debit
      description
    }
  }
  """
  test "deleteTransaction field deletes a transaction sucessfully" do
    user =
      Repo.insert!(%User{
        dob: "3/15/1980",
        first_name: "michael",
        last_name: "scott"
      })

    merchant =
      Repo.insert!(%Merchant{
        description: "Exotic Animal Zoo",
        name: "Greater Wynnewood Exotic Animal Park"
      })

    transaction =
      Repo.insert!(%Transaction{
        user_id: user.id,
        merchant_id: merchant.id,
        amount: 1111, # cents
        credit: true,
        debit: false,
        description: "test transaction 1"
      })

    conn = build_conn()

    conn =
      post(conn, "/graphiql",
        query: @query,
        variables: %{
          id: transaction.id
        }
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "deleteTransaction" => %{
                 "id" => transaction.id,
                 "user_id" => user.id,
                 "merchant_id" => merchant.id,
                 "amount" => "11.11",
                 "credit" => true,
                 "debit" => false,
                 "description" => "test transaction 1"
               }
             }
           }
  end
end
