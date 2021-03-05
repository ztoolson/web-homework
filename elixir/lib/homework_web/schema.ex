defmodule HomeworkWeb.Schema do
  @moduledoc """
  Defines the graphql schema for this project.
  """
  use Absinthe.Schema

  alias HomeworkWeb.Resolvers.MerchantsResolver
  alias HomeworkWeb.Resolvers.TransactionsResolver
  alias HomeworkWeb.Resolvers.UsersResolver
  import_types(HomeworkWeb.Schemas.Types)

  query do
    @desc "Get all Transactions"
    field(:transactions, list_of(:transaction)) do
      @desc "min is a filter for minimum amount value"
      arg(:min, :currency)

      @desc "max is a filter for maximum amount value"
      arg(:max, :currency)

      @desc "description is a filter that will search descriptions to match the requested input"
      arg(:description, :string)

      resolve(&TransactionsResolver.transactions/3)
    end

    @desc "Get all Users"
    field(:users, list_of(:user)) do
      resolve(&UsersResolver.users/3)
    end

    @desc "Get all Merchants"
    field(:merchants, list_of(:merchant)) do
      resolve(&MerchantsResolver.merchants/3)
    end
  end

  mutation do
    import_fields(:transaction_mutations)
    import_fields(:user_mutations)
    import_fields(:merchant_mutations)
  end

  scalar :currency do
    parse(fn
      %{value: value}, _ ->
        cents =
          value
          |> Decimal.cast()
          |> Decimal.mult(Decimal.new("100"))
          |> Decimal.to_integer()

        {:ok, cents}

      _, _ ->
        :error
    end)

    serialize(fn input ->
      :erlang.float_to_binary(input / 100.0, decimals: 2)
    end)
  end
end
