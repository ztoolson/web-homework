defmodule HomeworkWeb.Schema.Query.UpdateTransactionTest do
  use HomeworkWeb.ConnCase, async: true

  alias Homework.Repo
  alias Homework.Merchants.Merchant
  alias Homework.Transactions.Transaction
  alias Homework.Users.User

  @query """
  mutation UpdateTransaction($id: ID!, $user_id: UserID!, $merchant_id: MerchantID!, $amount: Amount!, $credit: Credit!, $debit: Debit!, $description: Description!) {
    updateTransaction(id: $id, user_id: $user_id, merchant_id: $merchant_id, amount: $amount, credit: $credit, debit: $debit, description: $description) {
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
  test "update field update an existing transaction sucessfully" do
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
          id: transaction.id,
          user_id: user.id,
          merchant_id: merchant.id,
          amount: "100000.00",
          credit: false,
          debit: true,
          description: "private tiger tour"
        }
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "updateTransaction" => %{
                 "id" => transaction.id,
                 "user_id" => user.id,
                 "merchant_id" => merchant.id,
                 "amount" => "100000.00",
                 "credit" => false,
                 "debit" => true,
                 "description" => "private tiger tour"
               }
             }
           }
  end
end
