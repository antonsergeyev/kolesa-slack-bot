defmodule Km.Meme do
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
    html = Floki.parse(get_page)
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
          image: Application.get_env(:km, :meme_source) <> src,
          text: Floki.DeepText.get(paragraph)
        }
    end)
  end

  defp clear_text(text) do
    String.strip(text)
    |> String.strip(?.)
    |> String.strip
    |> String.downcase
  end

  defp get_page() do
    case HTTPoison.get(Application.get_env(:km, :meme_source)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
       _ ->
        # todo: handle errors
        ""
    end
  end
end
