defmodule Frobots.ApiClient do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, Keyword.fetch!(Application.get_env(:phoenix_client, :api),:url))
  # generated this token from the server using jerry@frobots.io username.
  plug(Tesla.Middleware.BearerAuth,
    token: Application.get_env(:frobots, :bearer_token)
  )
  plug(Tesla.Middleware.JSON)

  @user_frobot_path Frobots.user_frobot_path()

  # dynamic user & pass
  def login_client(username, password, opts \\ %{}) do
    Tesla.client [
      {Tesla.Middleware.BaseUrl, Keyword.fetch!(Application.get_env(:phoenix_client, :token),:url) },
      Tesla.Middleware.JSON,
      {Tesla.Middleware.BasicAuth, Map.merge(%{username: username, password: password}, opts)}
    ]
  end

  def get_token(client) do
    # pass `client` argument to `Tesla.get` function
    case Tesla.get(client, "/generate/") do
      {:ok, %Tesla.Env{status: 200, body: %{"data"=>%{"token"=> token}}}} -> token
      {:error, error} -> error
    end
  end

  def get_user_frobots() do
    # this gets only the users frobots
    case get("/frobots") do
      {:ok, %Tesla.Env{body: %{"data" => frobot_list}}} ->
        Enum.map(frobot_list, fn frobot ->
          frobot
        end)

      {:error, error} ->
        [error]
    end
  end

  def get_template_frobots() do
    case get("/frobots/templates") do
      {:ok, %Tesla.Env{body: %{"data" => frobot_list}}} ->
        Enum.map(frobot_list, fn frobot -> frobot end)

      {:error, error} ->
        [error]
    end
  end

  def get_users() do
    get("/users")
  end

  def create_or_update_frobot(filename) do
    path = "/frobots"
    {:ok, code} = File.read(@user_frobot_path <> "/" <> filename)
    [name, _ext] = String.split(filename, ".")

    case ConCache.get(:frobots, name) do
      nil ->
        request_body = %{frobot: %{brain_code: code, name: name, class: "U"}}
        post(path, request_body)

      id ->
        update_path = path <> "/" <> Integer.to_string(id)
        request_body = %{frobot: %{brain_code: code}}
        put(update_path, request_body)
    end
  end

  def upload_user_frobots() do
    with {:ok, files} <- File.ls(@user_frobot_path),
         list <- Enum.filter(files, fn x -> String.contains?(x, ".lua") end) do
      Enum.map(list, &create_or_update_frobot/1)
    end
  end

  def delete_frobot(id) do
    path = "/frobots" <> "/" <> Integer.to_string(id)
    delete(path)
  end
end
