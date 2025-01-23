defmodule SquareggSite.Score do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias SquareggSite.Repo
  alias SquareggSite.Score

  schema "leaderboard" do
    field :user, :string
    field :score, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:user, :score])
    |> validate_required([:user, :score])
  end

  def subscribe do
    Phoenix.PubSub.subscribe(SquareggSite.PubSub, "recent_scores")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, score}, event) do
    Phoenix.PubSub.broadcast(SquareggSite.PubSub, "recent_scores", {event, score})
    {:ok, score}
  end

  def get_recent_scores do
    query = from(score in Score)
    Repo.all(query |> reverse_order())
  end

  def insert(user, score) do
    %Score{user: user, score: score}
    |> Score.changeset(%{})
    |> Repo.insert()
    |> broadcast(:insert)
  end
end
