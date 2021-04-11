defmodule FriendsApp.DB.CSV do
  alias Mix.Shell.IO, as: Shell
  alias FriendsApp.CLI.Menu
  alias FriendsApp.CLI.Friend
  alias NimbleCSV.RFC4180, as: CSVParser

  def perform(chosen_menu_item) do
    case chosen_menu_item do
      %Menu{label: _, id: :create} -> create()
      %Menu{label: _, id: :read} -> read()
      %Menu{label: _, id: :update} -> Shell.info(">>> UPDATE <<<")
      %Menu{label: _, id: :delete} -> Shell.info(">>> DELETE <<<")
    end

    FriendsApp.CLI.Menu.Choice.all()
  end

  defp read do
    File.read!("#{File.cwd!}/friends.csv")
      |> CSVParser.parse_string(headers: false)
      |> Enum.map(fn [email, name, phone] ->
        %{name: name, email: email, phone: phone}
      end)
      |> Scribe.console
  end

  defp create do
    collect_data
      |> Map.values()
      |> wrap_in_list
      |> CSVParser.dump_to_iodata()
      |> save_csv_file
    IO.puts "Cadastrado com sucesso"
  end

  defp collect_data do
    Shell.cmd("cls")

    %{
      name: prompt_message("Digite o nome: "),
      email: prompt_message("Digite o email: "),
      phone: prompt_message("Digite o phone: ")
    }
  end

  defp prompt_message(message) do
    Shell.prompt(message)
    |> String.trim()
  end

  defp wrap_in_list(list) do
    [list]
  end

  defp save_csv_file(data) do
    File.write!("#{File.cwd!()}/friends.csv", data, [:append])
  end
end
