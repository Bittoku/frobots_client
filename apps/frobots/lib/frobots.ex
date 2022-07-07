defmodule Frobots do
  @moduledoc """
  Frobots keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  @app :frobots
  @priv_dir "#{:code.priv_dir(@app)}"
  @bots_dir "bots"
  @template_dir "templates"

  alias Frobots.ApiClient
  alias Frobots.MatchChannelAdapter

  @doc """
    @frobot_types [
      {"Rabbit", :rabbit},
      {"Sniper", :sniper},
      {"Random", :random},
      {"Rook", :rook},
      {"Tracker", :tracker},
      {"Target", :target},
      {"Dummy", :dummy}
    ]


  """

  def user_frobot_path() do
    Path.join([@priv_dir, @bots_dir])
  end

  def template_frobot_path() do
    Path.join([@priv_dir, @template_dir])
  end


  def frobot_names(frobot_list) do
    Enum.map(frobot_list, fn f -> f["name"] end)
  end

  def frobot_types() do
    frobot_list = frobot_names(ApiClient.get_user_frobots() ++ ApiClient.get_template_frobots())
    Enum.map(frobot_list, fn x -> {x, String.to_atom(x)} end)
  end

  def start_fubars(frobots) do
    # return a frobots_map {name:frobot object_data}, but setup the channel adapter
    MatchChannelAdapter.start_match(MatchChannelAdapter, frobots)
  end

  def request_match() do
    MatchChannelAdapter.request_match(MatchChannelAdapter)
  end

  # this loads the frobots from server and saves them to the directory
  def load_player_frobots() do
    frobots = ApiClient.get_user_frobots()

    Enum.each(frobots, fn f ->
      ConCache.put(:frobots, f["name"], f["id"])
      File.mkdir_p!(user_frobot_path())
      File.write(~s|#{user_frobot_path()}/#{f["name"]}.lua|, f["brain_code"])
    end)

    templates = ApiClient.get_template_frobots()
    IO.inspect Enum.each(templates, fn f ->
      ConCache.put(:frobots, f["name"], f["id"])
      File.mkdir_p!(template_frobot_path())
      File.write(~s|#{template_frobot_path()}/#{f["name"]}.lua|, f["brain_code"])
    end)

  end

  # the following with read all the frobots in the local directory and upload them to the server.
  def save_player_frobots() do
    # first load all the frobots, so that we don't create duplicates
    frobots = ApiClient.get_user_frobots()

    Enum.each(frobots, fn f ->
      ConCache.put(:frobots, f["name"], f["id"])
    end)

    ApiClient.upload_user_frobots()
  end
end
