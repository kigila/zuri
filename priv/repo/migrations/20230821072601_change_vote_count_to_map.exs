defmodule Zuri.Repo.Migrations.ChangeVoteCountToMap do
  use Ecto.Migration

  def change do
    alter table(:faqs) do
      remove :vote_count, :integer
      add :vote_count, :map
    end
  end
end
