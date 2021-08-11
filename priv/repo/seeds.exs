# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rushing.Repo.insert!(%Rushing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rushing.Stats.RushStat
alias Rushing.Repo

file = File.open!("priv/repo/rushing.json", [:read])

Repo.transaction(fn ->
  IO.read(file, :all)
  |> Jason.decode!()
  |> Enum.each(fn json ->
    yds =
      case is_binary(json["Yds"]) do
        true ->
          {num, rem} = json["Yds"] |> String.replace(",", "") |> Float.parse()
          num

        false ->
          json["Yds"]
      end

    lng =
      case is_number(json["Lng"]) do
        true -> to_string(json["Lng"])
        false -> json["Lng"]
      end

    %RushStat{}
    |> RushStat.changeset(%{
      player: json["Player"],
      team: json["Team"],
      pos: json["Pos"],
      att: json["Att"],
      att_g: json["Att/G"],
      yds: yds,
      avg: json["Avg"],
      yds_g: json["Yds/G"],
      td: json["TD"],
      lng: lng,
      first: json["1st"],
      first_percent: json["1st%"],
      twenty_plus: json["20+"],
      fourty_plus: json["40+"],
      fumbles: json["FUM"]
    })
    |> Repo.insert!()
  end)
end)
