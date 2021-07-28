defmodule GakiBot.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";")

    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:uuid, :uuid, default: fragment("uuid_generate_v4()"), null: false)
      add(:telegram_id, :integer, null: false)
      add(:first_name, :string)
      add(:username, :string)

      timestamps()
    end

    create(unique_index(:users, :telegram_id))
    create index(:users, [:uuid])
  end
end
