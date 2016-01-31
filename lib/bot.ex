defmodule Km.Bot do
  use Slacker
  use Slacker.Matcher

  match ~r/как оно в кол[е|ё]сах/ui, :get_random
  match ~r/нормально делай$/ui, :get_normal
  match ~r/(.{5,})/ui, :get_by_text
  match ~r/как оно [#|№]\s?(\d+)/ui, :get_by_id

  def get_random(bot, msg) do
    send_meme(bot, msg["channel"], Km.Meme.get_random)
  end

  def get_normal(bot, msg) do
    say bot, msg["channel"], "— нормально будет."
  end

  def get_by_text(bot, msg, text) do
      meme = Km.Meme.get_by_text(text)

      if meme do
        send_meme(bot, msg["channel"], meme)
      end
  end

  def get_by_id(bot, msg, id) do
    meme = Km.Meme.get_by_id(String.to_integer(id))

    if meme do
      send_meme(bot, msg["channel"], meme)
    end
  end

  def send_meme(bot, channel, meme) do
    reply = meme.image <> "\n" <> meme.text
    say bot, channel, reply
  end

  def run do
    #start_link("xoxb-19885558611-Inmq7pdtBNovGM01q646I283")
    start_link(Application.get_env(:km, :slack_api_key))
  end
end
