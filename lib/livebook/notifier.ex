defmodule Livebook.Notifier do
  def notify(message_text) do
    http_post(webhook_url(), %{text: message_text})
  end

  defp http_post(uri, body) do
    with {:ok, body} <- Jason.encode(body),
         {:ok, http_response} <- :httpc.request(:post, {uri, [], 'application/json', body}, [], []),
         {_status, _headers, 'ok'} <- http_response do
      :ok
    end
  end

  def configured?(), do: webhook_url() != nil

  defp webhook_url() do
    if config = Application.get_env(:livebook, __MODULE__) do
      Keyword.get(config, :webhook_url)
    end
  end
end
