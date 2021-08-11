defmodule Rushing.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false

  alias Rushing.Repo

  alias Rushing.Stats.RushStat

  @doc """
  Returns the list of rushstats.

  This function can be passed, the page, limit, player_name, and sorts to handle.
  Page: int,
  limit: int,
  player_name: str,
  sorts: Map[field_name => direction]
  Where direction is an atom of either :desc, or :asc

  Specifically for sorting the LNG field. Since it's text, but we'd like to treat it
  as a number. We first modify the select query to add a lng_srt field with the trailing T's stripped out.
  This is then converted to an integer for sorting.
  Then, if "lng" is in the sort_map, we then add an order_by to the query. Otherwise we leave the query as is.
  """
  def list_rushstats(page \\ 0, limit \\ 50, player_name \\ "", sorts \\ %{}) do
    order_by =
      Enum.flat_map(sorts, fn {field_name, direction} ->
        case field_name do
          "lng" -> []
          _ -> [{direction, String.to_atom(field_name)}]
        end
      end)

    offset = page * limit

    query =
      from(p in "rushstats",
        select: [
          player: p.player,
          att: p.att,
          att_g: p.att_g,
          avg: p.avg,
          first: p.first,
          first_percent: p.first_percent,
          fourty_plus: p.fourty_plus,
          fumbles: p.fumbles,
          lng: p.lng,
          pos: p.pos,
          td: p.td,
          team: p.team,
          twenty_plus: p.twenty_plus,
          yds: p.yds,
          yds_g: p.yds_g,
          lng_sort: fragment("TRIM (TRAILING 'T' FROM ?)::integer AS lng_sort", p.lng)
        ],
        where: ilike(p.player, ^"%#{player_name}%"),
        order_by: ^order_by,
        offset: ^offset,
        limit: ^limit
      )

    lng_dir = Map.get(sorts, "lng")

    query =
      case lng_dir do
        :asc -> order_by(query, [p], fragment("lng_sort ASC"))
        :desc -> order_by(query, [p], fragment("lng_sort DESC"))
        _ -> query
      end

    stats = Repo.all(query)

    count =
      Repo.one(
        from(p in "rushstats",
          select: [p.count],
          where: ilike(p.player, ^"%#{player_name}%")
        )
      )
      |> Enum.at(0)

    {stats, count}
  end

  @doc """
  Gets a single rush_stat.

  Raises `Ecto.NoResultsError` if the Rush stat does not exist.

  ## Examples

      iex> get_rush_stat!(123)
      %RushStat{}

      iex> get_rush_stat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rush_stat!(id), do: Repo.get!(RushStat, id)

  @doc """
  Creates a rush_stat.

  ## Examples

      iex> create_rush_stat(%{field: value})
      {:ok, %RushStat{}}

      iex> create_rush_stat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rush_stat(attrs \\ %{}) do
    %RushStat{}
    |> RushStat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rush_stat.

  ## Examples

      iex> update_rush_stat(rush_stat, %{field: new_value})
      {:ok, %RushStat{}}

      iex> update_rush_stat(rush_stat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rush_stat(%RushStat{} = rush_stat, attrs) do
    rush_stat
    |> RushStat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rush_stat.

  ## Examples

      iex> delete_rush_stat(rush_stat)
      {:ok, %RushStat{}}

      iex> delete_rush_stat(rush_stat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rush_stat(%RushStat{} = rush_stat) do
    Repo.delete(rush_stat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rush_stat changes.

  ## Examples

      iex> change_rush_stat(rush_stat)
      %Ecto.Changeset{data: %RushStat{}}

  """
  def change_rush_stat(%RushStat{} = rush_stat, attrs \\ %{}) do
    RushStat.changeset(rush_stat, attrs)
  end
end
