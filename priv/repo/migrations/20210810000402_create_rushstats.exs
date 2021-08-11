defmodule Rushing.Repo.Migrations.CreateRushstats do
  use Ecto.Migration

  def change do
    create table(:rushstats) do
      add :player, :string
      add :team, :string
      add :pos, :string
      add :att, :integer
      add :att_g, :float
      add :yds, :float
      add :avg, :float
      add :yds_g, :float
      add :td, :integer
      add :lng, :string
      add :first, :integer
      add :first_percent, :float
      add :twenty_plus, :integer
      add :fourty_plus, :integer
      add :fumbles, :integer

      timestamps()
    end

  end
end
