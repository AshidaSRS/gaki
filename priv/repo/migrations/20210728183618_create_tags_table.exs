defmodule GakiBot.Repo.Migrations.CreateTagsTable do
  use Ecto.Migration

  def change do
    create table(:tags, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:uuid, :uuid,  default: fragment("uuid_generate_v4()"), null: false)
      add(:tag, :string)
      add(:active, :boolean)

      timestamps()
    end
    create(unique_index(:tags, :uuid))
  end
end
