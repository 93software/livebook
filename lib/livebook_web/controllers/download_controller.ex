defmodule LivebookWeb.DownloadController do
  use LivebookWeb, :controller

  alias Livebook.Session
  alias Livebook.LiveMarkdown

  def download_notebook(conn, %{"id" => session_id}) do
    data = Session.get_data(session_id)
    content = LiveMarkdown.Export.notebook_to_markdown(data.notebook)

    {:ok, tmp_file} = write_tmp_file(content)

    conn
    |> put_resp_header("content-disposition", "attachment; filename=#{notebook_filename(data.notebook)}")
    |> send_file(200, tmp_file)
  end

  defp write_tmp_file(content) do
    tmp_file = Path.join(System.tmp_dir!(), :crypto.strong_rand_bytes(8) |> Base.encode16())
    with :ok <- File.write(tmp_file, content), do: {:ok, tmp_file}
  end

  defp notebook_filename(notebook), do: notebook.name <> LiveMarkdown.extension()
end
