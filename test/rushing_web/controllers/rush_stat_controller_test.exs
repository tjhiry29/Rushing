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
  end

  describe "new rush_stat" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.rush_stat_path(conn, :new))
      assert html_response(conn, 200) =~ "New Rush stat"
    end
  end

  describe "create rush_stat" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.rush_stat_path(conn, :create), rush_stat: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.rush_stat_path(conn, :show, id)

      conn = get(conn, Routes.rush_stat_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Rush stat"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.rush_stat_path(conn, :create), rush_stat: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Rush stat"
    end
  end

  describe "edit rush_stat" do
    setup [:create_rush_stat]

    test "renders form for editing chosen rush_stat", %{conn: conn, rush_stat: rush_stat} do
      conn = get(conn, Routes.rush_stat_path(conn, :edit, rush_stat))
      assert html_response(conn, 200) =~ "Edit Rush stat"
    end
  end

  describe "update rush_stat" do
    setup [:create_rush_stat]

    test "redirects when data is valid", %{conn: conn, rush_stat: rush_stat} do
      conn = put(conn, Routes.rush_stat_path(conn, :update, rush_stat), rush_stat: @update_attrs)
      assert redirected_to(conn) == Routes.rush_stat_path(conn, :show, rush_stat)

      conn = get(conn, Routes.rush_stat_path(conn, :show, rush_stat))
      assert html_response(conn, 200) =~ "some updated lng"
    end

    test "renders errors when data is invalid", %{conn: conn, rush_stat: rush_stat} do
      conn = put(conn, Routes.rush_stat_path(conn, :update, rush_stat), rush_stat: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Rush stat"
    end
  end

  describe "delete rush_stat" do
    setup [:create_rush_stat]

    test "deletes chosen rush_stat", %{conn: conn, rush_stat: rush_stat} do
      conn = delete(conn, Routes.rush_stat_path(conn, :delete, rush_stat))
      assert redirected_to(conn) == Routes.rush_stat_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, Routes.rush_stat_path(conn, :show, rush_stat))
      end)
    end
  end

  defp create_rush_stat(_) do
    rush_stat = fixture(:rush_stat)
    %{rush_stat: rush_stat}
  end
end
