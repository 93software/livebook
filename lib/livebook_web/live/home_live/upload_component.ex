defmodule LivebookWeb.SessionLive.UploadComponent do
  use LivebookWeb, :live_component

  alias Livebook.LiveMarkdown

  @impl true
  def mount(socket) do
    {:ok, allow_upload(socket, :notebook, upload_opts())}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <form phx-submit="form:save" phx-change="form:validate" phx-target=<%= @myself %>>
      <div class="p-5 border border-gray-200 rounded-lg text-center" phx-drop-target="<%= @uploads.notebook.ref %>">
        <span class="font-semibold">
          <label class="text-blue-600 cursor-pointer" for="<%= @uploads.notebook.ref %>">
            Choose a <%= LiveMarkdown.extension() %> file
          </label>
          <span class="text-gray-600">
            or drag and drop here!
          </span>
        </span>
        <%= live_file_input @uploads.notebook, class: "hidden" %>
      </div>
    </form>
    """
  end

  @impl true
  def handle_event("form:" <> _event, _params, socket) do
    {:noreply, socket}
  end

  defp handle_progress(:notebook, entry, socket) do
    if entry.done? do
      ensure_upload_dir_exists()

      consume_uploaded_entries socket, :notebook, fn %{path: path}, _entry ->
        dest = Path.join(upload_dir(), entry.client_name)
        File.cp!(path, dest)
      end

      send_update(LivebookWeb.PathSelectComponent, id: "path_select")
    end
    {:noreply, socket}
  end

  defp ensure_upload_dir_exists() do
    unless File.dir?(upload_dir()), do: File.mkdir!(upload_dir())
  end

  defp upload_dir(), do: File.cwd!() |> Path.join("uploads")

  defp upload_opts() do
    [
      accept: [LiveMarkdown.extension()],
      max_entries: 10,
      auto_upload: true,
      progress: &handle_progress/3,
    ]
  end
end
