defmodule Mix.Tasks.Start do
  use Mix.Task

  @shortdoc "Start application"
  def run(_) do
    FriendsApp.init()
  end
end
