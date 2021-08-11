defmodule RushingWeb.RushStatController do
  use RushingWeb, :controller

  alias Rushing.Stats
  alias Rushing.Stats.RushStat

  def index(conn, params) do
    page = Map.get(params, "page", "0")

    parsed_page =
      case blank?(page) do
        true ->
          0

        _ ->
          {parsed_int, _} = Integer.parse(page)
          parsed_int
      end

    limit = Map.get(params, "limit", 50)
    player_name = Map.get(params, "name")

    sort_param = Map.get(params, "sorts", "")
    sorts = decode_sorts(sort_param)

    {rushstats, total_count} = Stats.list_rushstats(parsed_page, limit, player_name, sorts)
    total_pages = round(total_count / limit)

    conn
    |> assign(:sorts, sorts)
    |> assign(:page, parsed_page)
    |> assign(:player_name, player_name)
    |> assign(:total_pages, total_pages)
    |> assign(:rushstats, rushstats)
    |> render("index.html")
  end

  def new(conn, _params) do
    changeset = Stats.change_rush_stat(%RushStat{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"rush_stat" => rush_stat_params}) do
    case Stats.create_rush_stat(rush_stat_params) do
      {:ok, rush_stat} ->
        conn
        |> put_flash(:info, "Rush stat created successfully.")
        |> redirect(to: Routes.rush_stat_path(conn, :show, rush_stat))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rush_stat = Stats.get_rush_stat!(id)
    render(conn, "show.html", rush_stat: rush_stat)
  end

  def edit(conn, %{"id" => id}) do
    rush_stat = Stats.get_rush_stat!(id)
    changeset = Stats.change_rush_stat(rush_stat)
    render(conn, "edit.html", rush_stat: rush_stat, changeset: changeset)
  end

  def update(conn, %{"id" => id, "rush_stat" => rush_stat_params}) do
    rush_stat = Stats.get_rush_stat!(id)

    case Stats.update_rush_stat(rush_stat, rush_stat_params) do
      {:ok, rush_stat} ->
        conn
        |> put_flash(:info, "Rush stat updated successfully.")
        |> redirect(to: Routes.rush_stat_path(conn, :show, rush_stat))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", rush_stat: rush_stat, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rush_stat = Stats.get_rush_stat!(id)
    {:ok, _rush_stat} = Stats.delete_rush_stat(rush_stat)

    conn
    |> put_flash(:info, "Rush stat deleted successfully.")
    |> redirect(to: Routes.rush_stat_path(conn, :index))
  end

  defp decode_sorts("") do
    %{}
  end

  defp decode_sorts(sorts) do
    String.split(sorts, ",")
    |> Enum.map(fn str ->
      [key | val] = String.split(str, ":")
      [head | _] = val
      {key, head}
    end)
    |> Enum.reduce(
      %{},
      fn {key, val}, acc ->
        new_val =
          case val do
            "desc" -> :desc
            "asc" -> :asc
            _ -> :desc
          end

        Map.put(acc, key, new_val)
      end
    )
  end

  defp encode_sorts(sort_map) do
    Enum.map(fn {field, dir} ->
      nil
    end)
  end

  defp blank?(" ") do
    true
  end

  defp blank?("") do
    true
  end

  defp blank?(nil) do
    false
  end

  defp blank?(_) do
    false
  end
end
