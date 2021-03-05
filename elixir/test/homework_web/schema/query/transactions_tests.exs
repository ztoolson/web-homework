defmodule HomeworkWeb.Schema.Query.TransactionsTest do
  use HomeworkWeb.ConnCase, async: true

  alias Homework.Repo
  alias Homework.Users.User
  alias Homework.Transactions.Transaction
  alias Homework.Merchants.Merchant

  setup do
    Repo.delete_all(Transaction)
    Repo.delete_all(Merchant)
    Repo.delete_all(User)

    user =
      Repo.insert!(%User{
        dob: "1/1/1900",
        first_name: "zach",
        last_name: "toolson"
      })

    merchant =
      Repo.insert!(%Merchant{
        description: "The finest paper products",
        name: "Dunder Mifflin"
      })

    transactions = [
      %Transaction{
        # cents
        amount: 1111,
        credit: true,
        debit: false,
        description: "test transaction 1",
        user_id: user.id,
        merchant_id: merchant.id
      },
      %Transaction{
        # cents
        amount: 2222,
        credit: true,
        debit: false,
        description: "test transaction 2",
        user_id: user.id,
        merchant_id: merchant.id
      },
      %Transaction{
        # cents
        amount: 3333,
        credit: true,
        debit: false,
        description: "test transaction 3",
        user_id: user.id,
        merchant_id: merchant.id
      }
    ]

    Enum.each(transactions, fn transaction ->
      Repo.insert!(transaction)
    end)
  end

  @query """
  {
    transactions{
      amount
      credit
      debit
      description
    }
  }
  """
  test "get all transactions query returns a list of transactions" do
    conn = build_conn()
    conn = get(conn, "/graphiql", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "transactions" => [
                 %{
                   "amount" => "11.11",
                   "credit" => true,
                   "debit" => false,
                   "description" => "test transaction 1"
                 },
                 %{
                   "amount" => "22.22",
                   "credit" => true,
                   "debit" => false,
                   "description" => "test transaction 2"
                 },
                 %{
                   "amount" => "33.33",
                   "credit" => true,
                   "debit" => false,
                   "description" => "test transaction 3"
                 }
               ]
             }
           }
  end

  @min_query """
  {
    transactions(min: "15.00"){
      amount
      credit
      debit
      description
    }
  }
  """
  test "get transactions query with min filter returns a list of transactions above the min amount" do
    conn = build_conn()
    conn = get(conn, "/graphiql", query: @min_query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "transactions" => [
                 %{
                   "amount" => "22.22",
                   "credit" => true,
                   "debit" => false,
                   "description" => "test transaction 2"
                 },
                 %{
                   "amount" => "33.33",
                   "credit" => true,
                   "debit" => false,
                   "description" => "test transaction 3"
                 }
               ]
             }
           }
  end
end
