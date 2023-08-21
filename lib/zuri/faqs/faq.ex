defmodule Zuri.Faqs.Faq do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faqs" do
    field :answer, :map
    field :question, :string
    field :vote_count, :map
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(faq, attrs) do
    faq
    |> cast(attrs, [:question, :user_id])
    |> validate_required([:question, :user_id])
  end

  def changeset_answer(faq, attrs) do
    faq
    |> cast(attrs, [:answer, :user_id])
    |> validate_required([:answer, :user_id])
  end

  def changeset_vote_count(faq, attrs) do
    faq
    |> cast(attrs, [:vote_count, :user_id])
    |> validate_required([:vote_count, :user_id])
  end

end
