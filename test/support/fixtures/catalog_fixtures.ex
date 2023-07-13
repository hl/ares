defmodule Ares.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ares.Catalog` context.
  """

  def unique_product_sku, do: "sku#{System.unique_integer()}"
  def unique_product_price, do: :rand.uniform(9999)
  def unique_product_title, do: "product#{System.unique_integer()}"

  def valid_product_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      sku: unique_product_sku(),
      price: unique_product_price(),
      title: unique_product_title()
    })
  end

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> valid_product_attributes()
      |> Ares.Catalog.create_product()

    product
  end
end
