defmodule Km.Meme do
  def get_random() do
    Enum.random(get_all)
  end

  def get_by_id(id) do
    Enum.find(get_all, fn(meme) -> meme.id == id end)
  end

  def get_by_text(text) do
    Enum.find(get_all, fn(meme) -> meme.text == text end)
  end

  def get_all do
    html = Floki.parse(get_page())
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

  defp get_page() do
    case HTTPoison.get(Application.get_env(:km, :meme_source)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
       _ ->
        ""
    end
  end
end
