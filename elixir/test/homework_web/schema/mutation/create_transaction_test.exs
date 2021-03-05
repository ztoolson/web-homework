defmodule HomeworkWeb.Schema.Query.CreateTransactionTest do
  use HomeworkWeb.ConnCase, async: true

  alias Homework.Repo
  alias Homework.Merchants.Merchant
  alias Homework.Users.User

  @query """
  mutation CreateTransaction($user_id: UserID!, $merchant_id: MerchantID!, $amount: Amount!, $credit: Credit!, $debit: Debit!, $description: Description!) {
    createTransaction(user_id: $user_id, merchant_id: $merchant_id, amount: $amount, credit: $credit, debit: $debit, description: $description) {
      user_id
      merchant_id
      amount
      credit
      debit
      description
    }
  }
  """
  test "createTransaction field creates a transaction sucessfully" do
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

    conn = build_conn()

    conn =
      post(conn, "/graphiql",
        query: @query,
        variables: %{
          user_id: user.id,
          merchant_id: merchant.id,
          amount: 50000,
          credit: false,
          debit: true,
          description: "private tiger tour"
        }
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "createTransaction" => %{
                 "user_id" => user.id,
                 "merchant_id" => merchant.id,
                 "amount" => 50000,
                 "credit" => false,
                 "debit" => true,
                 "description" => "private tiger tour"
               }
             }
           }
  end
end
