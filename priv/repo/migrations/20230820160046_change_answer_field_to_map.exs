defmodule Zuri.Repo.Migrations.ChangeAnswerFieldToMap do
  use Ecto.Migration

  def change do
    alter table(:faqs) do
      remove :answer, :string
      add :answer, :map
    end
  end
end
