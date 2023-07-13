defmodule Ares.Catalog do
  @moduledoc """
  Catalog context
  """

  alias Ares.Catalog.Product
  alias Ares.Repo

  import Ares.Utils

  @spec list_products() :: [Product.t()]
  def list_products do
    Repo.all(Product)
  end

  @spec get_product(Product.id()) :: Product.t() | nil
  def get_product(id) do
    Repo.get(Product, id)
  end

  @spec create_product(map() | Keyword.t()) ::
          {:ok, Product.t()} | {:error, [{atom(), String.t()}]}
  def create_product(attrs) do
    product = struct(Product, attrs)
    store_product(product)
  end

  @spec update_product(Product.t(), map() | Keyword.t()) ::
          {:ok, Product.t()} | {:error, [{atom(), String.t()}]}
  def update_product(product, attrs) do
    product = struct(product, attrs)
    store_product(product)
  end

  @spec store_product(Product.t()) ::
          {:ok, Product.t()} | {:error, [{atom(), String.t()}]}
  def store_product(product) do
    with :ok <- validate_required(product, [:sku, :price]) do
      Repo.insert_or_update(product)
    end
  end

  @spec delete_product(Product.t()) :: {:ok, Product.t()}
  def delete_product(product) do
    Repo.delete(product)
  end
end
