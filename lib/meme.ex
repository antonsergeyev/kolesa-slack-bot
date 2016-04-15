defmodule Km.Meme do
  require Logger

  def get_random() do
    Enum.random(get_all)
  end

  def get_by_id(id) do
    Enum.find(get_all, fn(meme) -> meme.id == id end)
  end

  def get_by_text(text) do
    Enum.find(get_all, fn(meme) -> clear_text(meme.text) == clear_text(text) end)
  end

  def get_all do
    case Agent.get(:cache, &Map.get(&1, :memes, :empty)) do
      memes when is_list(memes) ->
        Logger.debug("got memes from cache");
        memes
      _ ->
        Logger.debug("no cached memes yet, parsing page");
        memes = get_from_page(get_page)

        Agent.update(:cache, &Map.put(&1, :memes, memes))

        memes
    end
  end

  defp clear_text(text) do
    String.strip(text)
    |> String.strip(?.)
    |> String.strip
    |> String.downcase
  end

  defp get_from_page(page) do
    html = Floki.parse(page)
    # parsing html with structure of
    # <p>meme 1 title</p><img data-src="meme-1-image.gif"/>
    # <p>meme 2 title</p><img data-src="meme-2-image.gif"/>
    paragraphs = Floki.find(html, "p")
    images = Floki.find(html, "img")

    Enum.with_index(images)
    |> Enum.map(
      fn({{_, attrs, _}, index}) ->
        src = elem(Enum.find(attrs, fn(attr) -> elem(attr, 0) == "data-src" end), 1)
        {_, _, paragraph} = Enum.at(paragraphs, index)

        %{
          id: index + 1,
          image: String.strip(Application.get_env(:km, :meme_img_host), ?/) <> src,
          text: Floki.DeepText.get(paragraph)
        }
    end)
  end

  def get_page() do
      url = Application.get_env(:km, :meme_source)
      {:ok, response} =  HTTPoison.get(url)

      encoding = Enum.into(response.headers, %{})["Content-Encoding"]

      case encoding do
        "gzip" -> :zlib.gunzip response.body
        nil    -> response.body
      end
    end
end
