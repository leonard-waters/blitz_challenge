defmodule BlitzChallenge.ConsoleMessage.Colorful do
  @behaviour BlitzChallenge.ConsoleMessage.Behaviour

  alias BlitzChallenge.RiotAPI.Util

  @background_color 53

  @input_color 183
  @input_text_color 53
  @input_size 20

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

  @label_color 15

  @impl BlitzChallenge.ConsoleMessage.Behaviour
  def print_message(message), do: draw_message_screen(message)
  @impl BlitzChallenge.ConsoleMessage.Behaviour
  def request_all_user_input do
    %{}
    |> Map.put(:summoner_name, request_input_by_type(:summoner_name))
    |> Map.put(:subdomain, request_input_by_type(:subdomain_input))
    |> then(fn
      %{subdomain: nil} = user_input ->
        Map.put(user_input, :region, request_input_by_type(:region))
        IO.write(@end_input_message)

      %{subdomain: subdomain} = user_input ->
        Map.put(user_input, :region, Util.find_region_by_subdomain(subdomain))
        IO.write(@end_input_message)
    end)
  end

  @impl BlitzChallenge.ConsoleMessage.Behaviour
  def request_subdomain_input, do: request_input_by_type(:subdomain_input)

  @impl BlitzChallenge.ConsoleMessage.Behaviour
  def request_region_input, do: request_input_by_type(:region)

  @impl BlitzChallenge.ConsoleMessage.Behaviour
  def request_summoner_name_input, do: request_input_by_type(:summoner_name)

  defp request_input_by_type(:subdomain_input) do
    draw_background()
    draw_input_screen(:subdomain_input)

    # read the entire line when the user presses Enter
    subdomain_input =
      :line
      |> IO.read()
      |> String.trim()
      |> then(fn
        "0" ->
          nil

        subdomain_number ->
          number = String.to_integer(subdomain_number) - 1
          Util.subdomains() |> Enum.find_value(number)
      end)

    reset()

    subdomain_input
  end

  defp request_input_by_type(:region) do
    draw_background()
    draw_input_screen(:region)

    # read the entire line when the user presses Enter
    region =
      :line
      |> IO.read()
      |> String.trim()
      |> then(fn region_number -> Map.get(@region_output_map, region_number) end)

    IO.ANSI.clear()

    region
  end

  defp request_input_by_type(:summoner_name) do
    draw_background()
    draw_input_screen(:summoner_name)

    # read the entire line when the user presses Enter
    summoner_name = IO.read(:line)

    reset()

    String.trim(summoner_name)
  end

  defp draw_message_screen(message) do
    {rows, cols} = screen_size()
    column = 5
    # floor to get the line just above center when rows or cols is odd
    # truncate to convert float to integer
    row = Float.floor(rows / 2) |> trunc()
    _input_box_column = Float.floor((cols - @input_size) / 2) |> trunc()

    # move the cursor to that position and draw the label
    IO.write(IO.ANSI.cursor(row, column) <> IO.ANSI.color(@label_color) <> message)

    :ok
  end

  defp draw_input_screen(:subdomain_input) do
    {rows, cols} = screen_size()

    # floor to get the line just above center when rows or cols is odd
    # truncate to convert float to integer
    start_column = 5
    start_row = 5
    row = Float.floor(rows / 2) |> trunc()
    input_box_column = Float.floor((cols - @input_size) / 2) |> trunc()

    IO.write(
      IO.ANSI.cursor(start_row, start_column) <>
        IO.ANSI.color(@label_color) <> @base_subdomain_input
    )

    # move the cursor to that position and draw the label
    {_row, _acc} = print_subdomain_prompt(start_row + 2, start_column)

    # move the cursor down a line and draw the input
    IO.write(
      IO.ANSI.cursor(row, input_box_column) <>
        IO.ANSI.color_background(@input_color) <> input_box()
    )

    # move the cursor to the beginning of the input
    IO.write(IO.ANSI.cursor(row, input_box_column) <> IO.ANSI.color(@input_text_color))
  end

  defp draw_input_screen(:region) do
    prompt = Map.fetch!(@input_type_label_map, :region)[:prompt]
    list = Map.fetch!(@input_type_label_map, :region)[:list]
    {rows, cols} = screen_size()
    column = 5
    end_of_text = prompt_cols(prompt) + column
    # floor to get the line just above center when rows or cols is odd
    # truncate to convert float to integer
    row = Float.floor(rows / 2) |> trunc()
    _input_box_column = Float.floor((cols - @input_size) / 2) |> trunc()

    # move the cursor to that position and draw the label
    IO.write(IO.ANSI.cursor(row, column) <> IO.ANSI.color(@label_color) <> prompt)
    IO.write(IO.ANSI.cursor(row + 1, column) <> IO.ANSI.color(@label_color) <> list)
    # move the cursor down a line and draw the input
    IO.write(
      IO.ANSI.cursor(row - 2, end_of_text) <>
        IO.ANSI.color_background(@input_color) <> input_box()
    )

    # move the cursor to the beginning of the input
    IO.write(IO.ANSI.cursor(row - 2, end_of_text) <> IO.ANSI.color(@input_text_color))
  end

  defp draw_input_screen(input_type) do
    label_type = Map.fetch!(@input_type_label_map, input_type)

    {rows, cols} = screen_size()

    # floor to get the line just above center when rows or cols is odd
    # truncate to convert float to integer
    row = Float.floor(rows / 2) |> trunc()
    column = Float.floor((cols - @input_size) / 2) |> trunc()

    # move the cursor to that position and draw the label
    IO.write(IO.ANSI.cursor(row, column) <> IO.ANSI.color(@label_color) <> label_type)

    # move the cursor down a line and draw the input
    IO.write(
      IO.ANSI.cursor(row + 1, column) <> IO.ANSI.color_background(@input_color) <> input_box()
    )

    # move the cursor to the beginning of the input
    IO.write(IO.ANSI.cursor(row + 1, column) <> IO.ANSI.color(@input_text_color))
  end

  defp input_box do
    String.duplicate(" ", @input_size)
  end

  defp draw_background do
    IO.write(IO.ANSI.color_background(@background_color) <> IO.ANSI.clear())
  end

  def reset do
    IO.write(IO.ANSI.reset() <> IO.ANSI.clear() <> IO.ANSI.home())
  end

  defp screen_size do
    {num("lines"), num("cols")}
  end

  defp num(subcommand) do
    case System.cmd("tput", [subcommand]) do
      {text, 0} ->
        text
        |> String.trim()
        |> String.to_integer()

      _ ->
        0
    end
  end

  def prompt_cols(prompt) do
    IO.iodata_length(prompt)
  end

  defp print_subdomain_prompt(row, column) do
    BlitzChallenge.RiotAPI.Util.subdomains()
    |> List.insert_at(0, "Do not know")
    |> Enum.reduce({row, 0}, fn subdomain, {row, acc} ->
      label = "#{acc}. #{subdomain}"
      IO.write(IO.ANSI.cursor(row, column) <> IO.ANSI.color(@label_color) <> label)

      {row + 1, acc + 1}
    end)
  end
end
