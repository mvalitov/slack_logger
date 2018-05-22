# SlackLogger

**A simple Logger backend for sending logs to slack. Is based on the library [LoggerFileBackend](https://github.com/onkel-dirtus/logger_file_backend)**



## Installation

Add `slack_logger` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:slack_logger, "~> 0.1.1"}
  ]
end
```

Documentation [https://hexdocs.pm/slack_logger](https://hexdocs.pm/slack_logger).

## Usage

In `*.exs`:

```elixir
config :logger,
    backends: [...
            {SlackLogger, :error}]

config :logger, :error,
    level: :error,
    url: "https://hooks.slack.com/services/***",
    format: "$date $time $metadata[$level] $message\n"
```