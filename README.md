# Smoothixir

**Smoothixir is a simple module that scraps the website https://www.allrecipes.com to get a list of smoothies recipe.**

## Explanations

This project is part of a tutorial that aims at showing how to do web scrapping using Elixir and two libraries: [HTTPoison](https://github.com/edgurgel/httpoison "HTTPoison") to fetch the page and [Floki](https://github.com/philss/floki "Floki") to parse HTML.

The tutorial was originally published on Medium : https://medium.com/@Jules_Corb/web-scraping-with-elixir-using-httpoison-and-floki-26ebaa03b076

## Run the code locally

if you want to run the code on your machine, use the following commands in your CLI:

`git clone https://github.com/JulienCorb/Smoothixir.git`

assuming you have a working environment for elixir:

`mix deps.get`

then use the elixir interractive shell to play around with the project:

`iex -S mix`

I wrote a comprehensive documentation to help you understand the project. Simply run `mix docs` and open `/doc/index.html` in your browser.

## Warning

This project was coded in March 2019 and might not be working in the future if allrecipes.com changes its UI. However, as mentionned above the goal of this project is to show how to do webscraping using Elixir.
