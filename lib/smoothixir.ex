defmodule Smoothixir do
  @moduledoc """
  Documentation for Smoothixir.
  Smoothixir is a scrapper module of the website allrecipes.com
  it aims at creating a list of smoothies with their name, ingredients and directions.
  """

  @doc """
  allows you to fetch all url of each smoothie receipe.

  ## Examples

      iex> Smoothixir.get_smoothies_url()
      {;ok,
      ["https://www.allrecipes.com/recipe/77035/kiwi-strawberry-smoothie/",
        "https://www.allrecipes.com/recipe/20816/delicious-healthy-strawberry-shake/",
        "https://www.allrecipes.com/recipe/23530/orange-smoothie/",
        "https://www.allrecipes.com/recipe/32425/mongolian-strawberry-orange-juice-smoothie/",
        "https://www.allrecipes.com/recipe/100822/heavenly-blueberry-smoothie/"]}

  """
  def get_smoothies_url() do
    case HTTPoison.get("https://www.allrecipes.com/recipes/138/drinks/smoothies/?internalSource=hubcard&referringContentType=Search&clickId=cardslot%201") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        urls =
            body
            |> Floki.find("a.fixed-recipe-card__title-link")
            |> Floki.attribute("href")

        {:ok, urls}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason

        end
  end

  @doc """
  once you have an array of all the URLs of smoothies pages, this function will get the HTML body of each of the page.

  ## Examples

      iex> Smoothixir.get_smoothies_url() |> Smoothixir.get_smoothies_html_body
      ["<!DOCTYPE html><html lang="en-us"><head><title>Kiwi Strawberry Smoothie Recipe - Allrecipes.com</title></head><body></body></html>"] # simplified for readability

  """
  def get_smoothies_html_body({_, urls}) do
    urls
    |> Enum.map(fn path -> HTTPoison.get(path) end)
    |> Enum.map(fn {_, result} -> result.body end)
  end

  @doc """
  Allow you to find the name of a smoothie within a page's html body.
  returns a String.

  ## Examples

      iex> Smoothixir.get_smoothie_name(body)
      "Mongolian Strawberry-Orange Juice Smoothie"

  """
   def get_smoothie_name(body) do
         body
         |> Floki.find("h1#recipe-main-content")
         |> Floki.text()
   end

   @doc """
   Allow you to find the ingredients of a smoothie within a page's html body.
   returns a List of strings.

   ## Examples

       iex> Smoothixir.get_smoothie_ingredients(body)
       ["1 cup chopped fresh strawberries", "1 cup orange juice", "10 cubes ice", "1 tablespoon sugar"]

   """
   def get_smoothie_ingredients(body) do
              body
              |> Floki.attribute("label", "title")
              |> Floki.text(sep: "+")
              |> String.split("+")
   end

   @doc """
   Allow you to find the directions of a smoothie within a page's html body.
   returns an Array of Strings.

   ## Examples

       iex> Smoothixir.get_smoothie_directions(body)
       ["In a blender, combine strawberries, orange juice, ice cubes and sugar. Blend until smooth. Pour into glasses and serve."]

   """
   def get_smoothie_directions(body) do
            body
            |> Floki.find("span.recipe-directions__list--item")
            |> Floki.text(sep: "=>")
            |> String.split("=>")
   end

   @doc """
   This is the main function of the module.
   It gathers all the previous functions and outputs a List of Maps of smoothies with name, ingredients, directions for each of them.

   ## Examples

        iex> Smoothixir.get_smoothies_recipe()
        {:ok,
          [%{
             directions: ["Cut banana into small pieces and place into the bowl of a blender.  Add the soy milk, yogurt, flax seed meal, and honey.  Blend on lowest speed until smooth, about 5 seconds.  Gradually add the blueberries while continuing to blend on low.  Once the blueberries have been incorporated, increase speed, and blend to desired consistency.                            "],
             ingredients: ["1 frozen banana, thawed for 10 to 15 minutes",
              "1/2 cup vanilla soy milk", "1 cup vanilla fat-free yogurt",
              "1 1/2 teaspoons flax seed meal", "1 1/2 teaspoons honey",
              "2/3 cup frozen blueberries"],
             name: "Heavenly Blueberry Smoothie"
           }
         ]}

   """
   def get_smoothies_recipe() do
     smoothies =
         get_smoothies_url()
         |> get_smoothies_html_body()
         |> Enum.map(fn body ->
           %{
             name: get_smoothie_name(body),
             ingredients: get_smoothie_ingredients(body),
             directions: get_smoothie_directions(body)
           }
         end
         )

     {:ok, smoothies}
   end

   @doc """
   Simple function that displays smoothies in a nice way in the console.

   ## Examples

       iex> Smoothixir.get_smoothies_recipe() |> Smoothixir.display_smoothies()
       Triple Threat Fruit Smoothie
       1 kiwi, sliced1 banana, peeled and chopped1/2 cup blueberries1 cup strawberries1 cup ice cubes1/2 cup orange juice1 (8 ounce) container peach yogurt
       In a blender, blend the kiwi, banana, blueberries, strawberries, ice, orange juice, and yogurt until smooth.

       +++++++++++++++++++++++++++++
       Groovie Smoothie
       2 small bananas, broken into chunks1 cup frozen unsweetened strawberries1 (8 ounce) container vanilla low-fat yogurt3/4 cup milk
       In a blender, combine bananas, frozen strawberries, yogurt and milk. Blend until smooth. Pour into glasses and serve.
   """
   def display_smoothies({_, smoothies}) do
     smoothies
     |> Enum.map(fn s ->
       IO.puts s.name
       IO.puts s.ingredients
       IO.puts s.directions
       IO.puts "+++++++++++++++++++++++++++++"
     end
     )
   end
end
