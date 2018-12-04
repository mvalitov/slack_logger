defmodule SlackLogger.Formatter do
  @moduledoc false

  def format_event(message, level, metadata) do
    Jason.encode!(%{
      attachments: [
        %{
          title: String.upcase(to_string(level)),
          pretext: format_message(message),
          text: format_metadata(metadata),
          color: format_level_color(level)
        }
      ]
    })
  end

  defp format_level_color(level) do
    case level do
      :error -> "danger"
      :warn -> "warning"
      :info -> "#439FE0"
      :debug -> "#b8babc"
    end
  end

  defp format_message(message) do
    message
    |> to_string
    |> String.trim()
    |> escape_special_chars()
    |> highlight_title()
  end

  defp escape_special_chars(message) do
    special_chars = [
      {"&", "&amp;"},
      {"<", "&lt;"},
      {">", "&gt;"}
    ]

    Enum.reduce(special_chars, message, fn {c, r}, acc ->
      String.replace(acc, c, r)
    end)
  end

  defp highlight_title(message) do
    message
    |> String.split("\n")
    |> Enum.join("\n")
  end

  defp format_metadata(metadata) do
    metadata
    |> Enum.map(fn {k, v} -> "#{k |> to_string() |> String.capitalize()}: #{inspect(v)}" end)
    |> Enum.join("\n")
  end
end
