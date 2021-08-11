defmodule RushingWeb.RushStatControllerTest do
  use RushingWeb.ConnCase

  alias Rushing.Stats

  @create_attrs %{
    att: 42,
    att_g: 120.5,
    avg: 120.5,
    first: 42,
    first_percent: 120.5,
    fourty_plus: 42,
    fumbles: 42,
    lng: "some lng",
    player: "some player",
    pos: "some pos",
    td: 42,
    team: "some team",
    twenty_plus: 42,
    yds: 120.5,
    yds_g: 120.5
  }
  @update_attrs %{
    att: 43,
    att_g: 456.7,
    avg: 456.7,
    first: 43,
    first_percent: 456.7,
    fourty_plus: 43,
    fumbles: 43,
    lng: "some updated lng",
    player: "some updated player",
    pos: "some updated pos",
    td: 43,
    team: "some updated team",
    twenty_plus: 43,
    yds: 456.7,
    yds_g: 456.7
  }
  @invalid_attrs %{
    att: nil,
    att_g: nil,
    avg: nil,
    first: nil,
    first_percent: nil,
    fourty_plus: nil,
    fumbles: nil,
    lng: nil,
    player: nil,
    pos: nil,
    td: nil,
    team: nil,
    twenty_plus: nil,
    yds: nil,
    yds_g: nil
  }

  def fixture(:rush_stat) do
    {:ok, rush_stat} = Stats.create_rush_stat(@create_attrs)
    rush_stat
  end

  describe "index" do
    test "lists all rushstats", %{conn: conn} do
      conn = get(conn, Routes.rush_stat_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Rushstats"
    end

    test "allows name, page, sorts query params all rushstats", %{conn: conn} do
      conn = get(conn, "#{Routes.rush_stat_path(conn, :index)}?name=some&sorts=player:asc&page=0")
      assert html_response(conn, 200) =~ "Listing Rushstats"
    end
  end

  defp create_rush_stat(_) do
    rush_stat = fixture(:rush_stat)
    %{rush_stat: rush_stat}
  end
end
