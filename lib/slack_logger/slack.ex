defmodule SlackLogger.Slack do

  @headers [{"Content-Type", "application/json"}]

  def post_log(url, output) do
    case HTTPoison.post(url, output, @headers) do
      {:ok, %HTTPoison.Response{body: "ok"}} -> true
      {:error, reason} -> IO.inspect(reason)
    end
  end

end
