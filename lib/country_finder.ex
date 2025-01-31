defmodule CountryFinder do
  @moduledoc """
  CountryFinder keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias CountryFinder.CountryClient
  alias CountryFinder.Country

  @doc """
  Returns a list of country structs
  """
  def all_countries() do
    case CountryClient.all_countries() do
      {:ok, %Finch.Response{status: 200, body: body}} ->
        body
        |> Jason.decode!()
        |> maps_to_structs()

      _ ->
        :error
    end
  end

  defp maps_to_structs(list_of_countries) do
    Enum.map(list_of_countries, fn country_map ->
      name = get_in(country_map, ["name", "common"])
      flag_png = get_in(country_map, ["flags", "png"])
      region = country_map["region"]
      capital = country_map["capital"]
      population = country_map["population"]
      country_alpha_code = country_map["cca3"]

      %Country{
        name: name,
        flag_png: flag_png,
        region: region,
        capital: capital,
        population: population,
        country_alpha_code: country_alpha_code
      }
    end)
  end



  @moduledoc """
  Formats a number by adding commas as thousands separators.
  """
  def format_number(number) do
    number
    |> Integer.to_charlist
    |> Enum.reverse
    |> Enum.chunk_every(3, 3, [])
    |> Enum.join(",")
    |> String.reverse
  end

end
