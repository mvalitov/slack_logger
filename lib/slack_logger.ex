defmodule SlackLogger do
  alias SlackLogger.{Slack, Formatter}
  @moduledoc """
  """

  @behaviour :gen_event

  @default_format "$time $metadata[$level] $message\n"

  def init({__MODULE__, name}) do
    {:ok, configure(name, [])}
  end

  def handle_call({:configure, opts}, %{name: name} = state) do
    {:ok, :ok, configure(name, opts, state)}
  end

  def handle_event({level, _gl, {Logger, msg, ts, md}}, %{level: min_level, metadata_filter: metadata_filter} = state) do
    if (is_nil(min_level) or Logger.compare_levels(level, min_level) != :lt) and metadata_matches?(md, metadata_filter) do
      log_event(level, msg, ts, md, state)
    else
      {:ok, state}
    end
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  defp log_event(_level, _msg, _ts, _md, %{url: nil} = state) do
    {:ok, state}
  end

  defp log_event(level, msg, _ts, md, %{url: url} = state) when is_binary(url) do
    Slack.post_log(url, Formatter.format_event(msg, level, md))
    {:ok, state}
  end

  defp configure(name, opts) do
    state = %{name: nil, format: nil, level: nil, metadata: nil, metadata_filter: nil, url: nil}
    configure(name, opts, state)
  end

  defp configure(name, opts, state) do
    env = Application.get_env(:logger, name, [])
    opts = Keyword.merge(env, opts)
    Application.put_env(:logger, name, opts)

    level           = Keyword.get(opts, :level)
    metadata        = Keyword.get(opts, :metadata, [])
    format_opts     = Keyword.get(opts, :format, @default_format)
    format          = Logger.Formatter.compile(format_opts)
    metadata_filter = Keyword.get(opts, :metadata_filter)
    url             = Keyword.get(opts, :url)

    %{state | name: name, format: format, level: level, metadata: metadata, metadata_filter: metadata_filter, url: url}
  end

  @doc false
  @spec metadata_matches?(Keyword.t, nil|Keyword.t) :: true|false
  def metadata_matches?(_md, nil), do: true
  def metadata_matches?(_md, []), do: true # all of the filter keys are present
  def metadata_matches?(md, [{key, val}|rest]) do
    case Keyword.fetch(md, key) do
      {:ok, ^val} ->
        metadata_matches?(md, rest)
      _ -> false #fail on first mismatch
    end
  end

end
