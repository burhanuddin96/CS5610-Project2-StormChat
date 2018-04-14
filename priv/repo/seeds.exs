# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Stormchat.Repo.insert!(%Stormchat.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Seeds do
  alias Stormchat.Repo
  alias Stormchat.Users.User
  alias Stormchat.Locations
  alias Stormchat.Locations.Location

  def run do
    ph1 = Comeonin.Argon2.hashpwsalt("password1");
    ph2 = Comeonin.Argon2.hashpwsalt("password2");
    ph3 = Comeonin.Argon2.hashpwsalt("password3");
    ph4 = Comeonin.Argon2.hashpwsalt("password4");

    Repo.delete_all(User)
    a = Repo.insert!(%User{ name: "alice", email: "alice@example.com", phone: "8572721850", password_hash: ph1 })
    b = Repo.insert!(%User{ name: "bob", email: "bob@example.com", phone: "5555550002", password_hash: ph2 })
    c = Repo.insert!(%User{ name: "carol", email: "carol@example.com", phone: "5555550003", password_hash: ph3 })
    d = Repo.insert!(%User{ name: "dave", email: "dave@example.com", phone: "5555550004", password_hash: ph4 })

    Repo.delete_all(Location)
    Locations.create_location(%{description: "home", user_id: 1, lat: 40.600577, long: -102.858589})
  end
end

Seeds.run
