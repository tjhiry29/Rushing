defmodule Rushing.StatsTest do
  use Rushing.DataCase

  alias Rushing.Stats

  describe "rushstats" do
    alias Rushing.Stats.RushStat

    @valid_attrs %{
      att: 42,
      att_g: 120.5,
      avg: 120.5,
      first: 42,
      first_percent: 120.5,
      fourty_plus: 42,
      fumbles: 42,
      lng: "100",
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
      lng: "125T",
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

    def rush_stat_fixture(attrs \\ %{}) do
      {:ok, rush_stat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Stats.create_rush_stat()

      rush_stat
    end

    def rush_stat_to_keyword_list(rush_stat) do
      {lng_sort, _} = String.replace_trailing(rush_stat.lng, "T", "") |> Integer.parse()

      Map.from_struct(rush_stat)
      |> Map.delete(:updated_at)
      |> Map.delete(:inserted_at)
      |> Map.delete(:__meta__)
      |> Map.delete(:id)
      |> Enum.map(fn {key, val} ->
        {key, val}
      end)
      |> Enum.concat(lng_sort: lng_sort)
    end

    test "list_rushstats/0 returns all rushstats" do
      rush_stat = rush_stat_fixture()
      assert Stats.list_rushstats() == {[rush_stat_to_keyword_list(rush_stat)], 1}
    end

    test "list_rushstats allows querying by name" do
      rush_stat1 = rush_stat_fixture()
      rush_stat2 = rush_stat_fixture(%{player: "asdf"})
      assert Stats.list_rushstats(0, 50, "asdf") == {[rush_stat_to_keyword_list(rush_stat2)], 1}
    end

    test "list_rushstats allows sorting by yds" do
      rush_stat1 = rush_stat_fixture()
      rush_stat2 = rush_stat_fixture(%{player: "asdf", yds: 2})

      assert Stats.list_rushstats(0, 50, "", %{"yds" => :desc}) ==
               {[rush_stat_to_keyword_list(rush_stat1), rush_stat_to_keyword_list(rush_stat2)], 2}
    end

    test "list_rushstats allows sorting by lng" do
      rush_stat1 = rush_stat_fixture()
      rush_stat2 = rush_stat_fixture(%{player: "asdf", lng: "100T"})

      assert Stats.list_rushstats(0, 50, "", %{"lng" => :desc}) ==
               {[rush_stat_to_keyword_list(rush_stat1), rush_stat_to_keyword_list(rush_stat2)], 2}
    end

    test "list_rushstats allows sorting by TD" do
      rush_stat1 = rush_stat_fixture()
      rush_stat2 = rush_stat_fixture(%{player: "asdf", td: 1})

      assert Stats.list_rushstats(0, 50, "", %{"td" => :desc}) ==
               {[rush_stat_to_keyword_list(rush_stat1), rush_stat_to_keyword_list(rush_stat2)], 2}
    end

    test "list_rushstats allows sorting by TD and searching by name" do
      # Create 2 rush stats
      _rush_stat1 = rush_stat_fixture()
      rush_stat2 = rush_stat_fixture(%{player: "asdf", td: 1})

      assert Stats.list_rushstats(0, 50, "asdf", %{"td" => :desc}) ==
               {[rush_stat_to_keyword_list(rush_stat2)], 1}
    end

    test "get_rush_stat!/1 returns the rush_stat with given id" do
      rush_stat = rush_stat_fixture()
      assert Stats.get_rush_stat!(rush_stat.id) == rush_stat
    end

    test "create_rush_stat/1 with valid data creates a rush_stat" do
      assert {:ok, %RushStat{} = rush_stat} = Stats.create_rush_stat(@valid_attrs)
      assert rush_stat.att == 42
      assert rush_stat.att_g == 120.5
      assert rush_stat.avg == 120.5
      assert rush_stat.first == 42
      assert rush_stat.first_percent == 120.5
      assert rush_stat.fourty_plus == 42
      assert rush_stat.fumbles == 42
      assert rush_stat.lng == "100"
      assert rush_stat.player == "some player"
      assert rush_stat.pos == "some pos"
      assert rush_stat.td == 42
      assert rush_stat.team == "some team"
      assert rush_stat.twenty_plus == 42
      assert rush_stat.yds == 120.5
      assert rush_stat.yds_g == 120.5
    end

    test "create_rush_stat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stats.create_rush_stat(@invalid_attrs)
    end

    test "update_rush_stat/2 with valid data updates the rush_stat" do
      rush_stat = rush_stat_fixture()
      assert {:ok, %RushStat{} = rush_stat} = Stats.update_rush_stat(rush_stat, @update_attrs)
      assert rush_stat.att == 43
      assert rush_stat.att_g == 456.7
      assert rush_stat.avg == 456.7
      assert rush_stat.first == 43
      assert rush_stat.first_percent == 456.7
      assert rush_stat.fourty_plus == 43
      assert rush_stat.fumbles == 43
      assert rush_stat.lng == "125T"
      assert rush_stat.player == "some updated player"
      assert rush_stat.pos == "some updated pos"
      assert rush_stat.td == 43
      assert rush_stat.team == "some updated team"
      assert rush_stat.twenty_plus == 43
      assert rush_stat.yds == 456.7
      assert rush_stat.yds_g == 456.7
    end

    test "update_rush_stat/2 with invalid data returns error changeset" do
      rush_stat = rush_stat_fixture()
      assert {:error, %Ecto.Changeset{}} = Stats.update_rush_stat(rush_stat, @invalid_attrs)
      assert rush_stat == Stats.get_rush_stat!(rush_stat.id)
    end

    test "delete_rush_stat/1 deletes the rush_stat" do
      rush_stat = rush_stat_fixture()
      assert {:ok, %RushStat{}} = Stats.delete_rush_stat(rush_stat)
      assert_raise Ecto.NoResultsError, fn -> Stats.get_rush_stat!(rush_stat.id) end
    end

    test "change_rush_stat/1 returns a rush_stat changeset" do
      rush_stat = rush_stat_fixture()
      assert %Ecto.Changeset{} = Stats.change_rush_stat(rush_stat)
    end
  end
end
