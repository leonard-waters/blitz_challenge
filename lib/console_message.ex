defmodule BlitzChallenge.ConsoleMessage do
  @behaviour BlitzChallenge.ConsoleMessage.Behaviour

  alias BlitzChallenge.RiotAPI.Util

  @input_type_label_map %{
    region: %{
      prompt: "Enter a number for the corresponding region and then enter: ",
      list: """
      1. Americas (NA)
      2. Asia (KR or JP)
      3. Europe (EU)
      4. Southeast Asia (SEA)
      """
    },
    summoner_name: "Enter Summoner Name and then enter: "
  }

  @base_subdomain_input """
  If you know the server subdomain please enter the corresponding number, otherwise hit `0` and then enter:
  """

  @region_output_map %{
    "1" => "americas",
    "2" => "asia",
    "3" => "europe",
    "4" => "sea"
  }

  @end_input_message "\n Thank you! \n\n"

  @impl BlitzChallenge.ConsoleMessage.Behaviour
  def print_message(message), do: print_console_message(message)
  @impl BlitzChallenge.ConsoleMessage.Behaviour
  def request_all_user_input do
    %{}
    |> Map.put(:summoner_name, request_input_by_type(:summoner_name))
    |> Map.put(:subdomain, request_input_by_type(:subdomain))
    |> then(fn
      %{subdomain: nil} = user_input ->
        IO.write(@end_input_message)
        Map.put(user_input, :region, request_input_by_type(:region))

      %{subdomain: subdomain} = user_input ->
        IO.write(@end_input_message)
        Map.put(user_input, :region, Util.find_region_by_subdomain(subdomain))
    end)
  end

  defp request_input_by_type(:summoner_name) do
    IO.puts(@input_type_label_map[:summoner_name])

    :line
    |> IO.read()
    |> String.trim()
    |> String.replace(" ", "")
  end

  defp request_input_by_type(:subdomain) do
    IO.puts(@base_subdomain_input)

    subdomain_map =
      BlitzChallenge.RiotAPI.Util.subdomains()
      |> List.insert_at(0, "Do not know")
      |> Enum.with_index(0)
      |> Enum.reduce(%{}, fn {subdomain, index}, acc ->
        label = "#{index}. #{subdomain}"
        IO.puts(label)
        Map.put(acc, index, subdomain)
      end)

    :line
    |> IO.read()
    |> String.trim()
    |> then(fn
      "0" ->
        nil

      subdomain_number ->
        number = String.to_integer(subdomain_number)
        Map.get(subdomain_map, number)
    end)
  end

  defp request_input_by_type(:region) do
    prompt = Map.fetch!(@input_type_label_map, :region)[:prompt]
    list = Map.fetch!(@input_type_label_map, :region)[:list]

    IO.puts(prompt)
    IO.puts(list)

    :line
    |> IO.read()
    |> String.trim()
    |> then(fn region_number -> Map.get(@region_output_map, region_number) end)
  end

  defp print_console_message(message) do
    IO.puts(message)
  end
end
