defmodule SquareggSite.Chat do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias SquareggSite.Repo
  alias SquareggSite.Chat

  schema "chat" do
    field :user, :string
    field :message, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:user, :message])
    |> validate_required([:user, :message])
  end

  def subscribe do
    Phoenix.PubSub.subscribe(SquareggSite.PubSub, "chat")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, score}, event) do
    Phoenix.PubSub.broadcast(SquareggSite.PubSub, "chat", {event, score})
    {:ok, score}
  end

  def get_chat do
    query = from(message in Chat)
    Repo.all(query |> reverse_order())
  end

  def insert(user, message) do
    %Chat{user: user, message: message}
    |> Chat.changeset(%{})
    |> Repo.insert()
    |> broadcast(:insert)
  end
end
