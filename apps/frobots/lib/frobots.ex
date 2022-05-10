defmodule Frobots do
  @moduledoc """
  Frobots keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  @app :frobots
  @priv_dir "#{:code.priv_dir(@app)}"
  @templates_dir "templates"
  @bots_dir "bots"

  alias Frobots.ApiClient
  alias Frobots.MatchChannelAdapter

  @frobot_types [
    {"Rabbit", :rabbit},
    {"Sniper", :sniper},
    {"Random", :random},
    {"Rook", :rook},
    {"Tracker", :tracker},
    {"Target", :target},
    {"Dummy", :dummy}
  ]

  def user_frobot_path() do
    Path.join([@priv_dir, @bots_dir])
  end

  def frobot_names(frobot_list) do
    Enum.map(frobot_list, fn f -> f["name"] end)
  end

  def frobot_types() do
    frobot_list = frobot_names( ApiClient.get_user_frobots() ++ ApiClient.get_template_frobots())
    Enum.map(frobot_list, fn x -> {x, String.to_atom(x)} end)
  end

  def start_frobots(frobots) do
    # return a frobots_map {name:frobot object_data}, but setup the channel adapter
    {:ok, frobots_map} = MatchChannelAdapter.start(MatchChannelAdapter, frobots)
    frobots_map
  end

  # these update functions scan the local priv/bots directory and will save these frobots to the server
  def load_player_frobot(name) do
    frobots = ApiClient.get_user_frobots()
    Enum.each(frobots, fn f ->
      ConCache.put(:frobots, f["name"], f["id"])
      File.write(~s|#{user_frobot_path()}/#{f["name"]}.lua|, f["brain_code"])
    end)
  end

  # this loads the frobots from server and saves them to the directory
  def load_player_frobots() do
    Enum.each(ApiClient.get_user_frobots(), fn name -> load_player_frobot(name) end)
  end

  def save_player_frobots() do
    ApiClient.upload_all_frobots()
  end
end
