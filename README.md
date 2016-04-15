# Kolesa developers slack bot

A minimal viable version of simple slack bot that can tell a bunch of stories about development routines at kolesa team.
Based on a [collection of memes](http://iborodikhin.net/kolesa/) by [Igor Borodikhin](https://github.com/iborodikhin).

## Installation and running

You need to have [Elixir](http://elixir-lang.org/) installed, and a slack bot registered with some API key

```
  > mix deps.get
  > export slack_api_key=###your slack api key###
  > iex -S mix
```

## Commands

To see the gifs, just cite some quotes from [http://iborodikhin.net/kolesa/](http://iborodikhin.net/kolesa/)

  > Отправили лишних 200К писем
  > ![](http://iborodikhin.net/kdb/80a10f54-7cc1-4493-9058-ed2cef9d0335.gif)


or try a random one:

  > how is it going at kolesa?
  > ![](http://iborodikhin.net/kdb/b030f0d5-0daf-4cea-b9c2-6db1e296c248.gif)
  >


If you want the bot to fetch the most fresh and moist memes from the web page when it's already running, just ask:


  > can i haz new memes?
  > done

