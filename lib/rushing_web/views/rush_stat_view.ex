defmodule RushingWeb.RushStatView do
  use RushingWeb, :view

  def get_current_sort(conn) do
    keys = Map.keys(conn.assigns.sorts)

    case Enum.count(keys) do
      1 -> Enum.map(conn.assigns.sorts, fn {key, val} -> "#{key}:#{val}" end)
      0 -> ""
    end
  end

  def get_sort_string(conn, field) do
    in_map = Map.get(conn.assigns.sorts, field)

    case in_map do
      :asc -> "#{field}:desc"
      :desc -> "#{field}:asc"
      _ -> "#{field}:desc"
    end
  end

  def sorts_to_string(sorts) do
    Enum.map(sorts, fn {key, order} ->
      "#{key}:#{order}"
    end)
    |> Enum.join(",")
  end

  def calculate_sort(conn, "") do
    conn.assigns.sorts
  end

  def calculate_sort(conn, field) do
    [field_name, dir] = String.split(field, ":")
    Map.put(%{}, field_name, dir)
  end

  def build_link(conn, next_page \\ 0, new_sort \\ "") do
    sort = calculate_sort(conn, new_sort)

    Routes.rush_stat_path(conn, :index) <>
      "?page=#{next_page}&sorts=#{sorts_to_string(sort)}&name=#{conn.assigns.player_name}"
  end
end
