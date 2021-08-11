# Rushing

# theScore "the Rush" Interview Challenge

At theScore, we are always looking for intelligent, resourceful, full-stack developers to join our growing team. To help us evaluate new talent, we have created this take-home interview question. This question should take you no more than a few hours.

**All candidates must complete this before the possibility of an in-person interview. During the in-person interview, your submitted project will be used as the base for further extensions.**

### Why a take-home challenge?

In-person coding interviews can be stressful and can hide some people's full potential. A take-home gives you a chance work in a less stressful environment and showcase your talent.

We want you to be at your best and most comfortable.

### A bit about our tech stack

As outlined in our job description, you will come across technologies which include a server-side web framework (like Elixir/Phoenix, Ruby on Rails or a modern Javascript framework) and a front-end Javascript framework (like ReactJS)

### Challenge Background

We have sets of records representing football players' rushing statistics. All records have the following attributes:

- `Player` (Player's name)
- `Team` (Player's team abbreviation)
- `Pos` (Player's postion)
- `Att/G` (Rushing Attempts Per Game Average)
- `Att` (Rushing Attempts)
- `Yds` (Total Rushing Yards)
- `Avg` (Rushing Average Yards Per Attempt)
- `Yds/G` (Rushing Yards Per Game)
- `TD` (Total Rushing Touchdowns)
- `Lng` (Longest Rush -- a `T` represents a touchdown occurred)
- `1st` (Rushing First Downs)
- `1st%` (Rushing First Down Percentage)
- `20+` (Rushing 20+ Yards Each)
- `40+` (Rushing 40+ Yards Each)
- `FUM` (Rushing Fumbles)

In this repo is a sample data file [`rushing.json`](/rushing.json).

##### Challenge Requirements

1. Create a web app. This must be able to do the following steps
   1. Create a webpage which displays a table with the contents of [`rushing.json`](/rushing.json)
   2. The user should be able to sort the players by _Total Rushing Yards_, _Longest Rush_ and _Total Rushing Touchdowns_
   3. The user should be able to filter by the player's name
   4. The user should be able to download the sorted data as a CSV, as well as a filtered subset
2. The system should be able to potentially support larger sets of data on the order of 10k records.

3. Update the section `Installation and running this solution` in the README file explaining how to run your code

### Submitting a solution

1. Download this repo
2. Complete the problem outlined in the `Requirements` section
3. In your personal public GitHub repo, create a new public repo with this implementation
4. Provide this link to your contact at theScore

We will evaluate you on your ability to solve the problem defined in the requirements section as well as your choice of frameworks, and general coding style.

### Help

If you have any questions regarding requirements, do not hesitate to email your contact at theScore for clarification.

### Installation and running this solution

For this project to run, you'll need at least Elixir 1.6, along with phoenix 1.5.9.
You can seee these deps in the `mix.exs` file. You'll also need an installation of PostgreSQL, the connection details for which you can see in the `devs.exs` file.

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup` this should also run seed scripts.
- Install Node.js dependencies with `npm install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Solution Description

I chose to use Elixir + Phoenix for this project as it was most closely related to the work I assume is being done at theScore. Many different solutions exist for this project.
As for front-end technologies, I decided to stick with simpler eex rendered templates as the amount of work to create a React application with a JSON API and figure that out was likely too much.

First. I created the model for each RushStat record based on the provided JSON. I figured out types as best as I could, I noticed a few fields were likely meant to be integers or floats rather than strings and properly converted those, but I left LNG as it was since the touchdown indicator was an important factor.
Then, after creating the model I downloaded the JSON file to the repository, and filled in the seeding script to fill in the database with data from the JSON file. At this point, I also performed the data cleaning necessary for any fields with strange or incorrect data.

Second. I setup a router to route any GET requests on `/` to `RushStatController#index`.

Third. I am relatively inexperienced with Ecto, with only the simplest of queries so this was a bit difficult. We dynamically create a query based on provided user inputs. If they provide a player name we do an ILIKE query on the player name with provided input. If they provide a sort direction and field, we dynamically apply the order_by. Finally, a page should be expected to be provided, so we also offset and limit the output based on the pagination.

Finally, we wire up the front-end using `eex` templates. This was a relatively simple page. If I had more time I would have liked to replace this using either Phoenix LiveView or maybe even a simple React application could work.

Testing is a bit difficult here, but for testing scenarios I can imagine, we simply want to ensure that sorting, querying by player name, and pagination works. I believe that these are the main things we should test. We may even want to test the helper functions, especially the ones dealing with the `sorts` map placed in the connections `assigns`.
