defmodule Rushing.Stats.RushStat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rushstats" do
    field(:att, :integer)
    field(:att_g, :float)
    field(:avg, :float)
    field(:first, :integer)
    field(:first_percent, :float)
    field(:fourty_plus, :integer)
    field(:fumbles, :integer)
    field(:lng, :string)
    field(:player, :string)
    field(:pos, :string)
    field(:td, :integer)
    field(:team, :string)
    field(:twenty_plus, :integer)
    field(:yds, :float)
    field(:yds_g, :float)

    timestamps()
  end

  @doc false
  def changeset(rush_stat, attrs) do
    rush_stat
    |> cast(attrs, [
      :player,
      :team,
      :pos,
      :att,
      :att_g,
      :yds,
      :avg,
      :yds_g,
      :td,
      :lng,
      :first,
      :first_percent,
      :twenty_plus,
      :fourty_plus,
      :fumbles
    ])
    |> validate_required([
      :player,
      :team,
      :pos,
      :att,
      :att_g,
      :yds,
      :avg,
      :yds_g,
      :td,
      :lng,
      :first,
      :first_percent,
      :twenty_plus,
      :fourty_plus,
      :fumbles
    ])
  end
end
