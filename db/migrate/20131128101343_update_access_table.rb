class UpdateAccessTable < ActiveRecord::Migration
  def change
    rename_column(:accesses, :password, :password_hash)
    remove_column(:accesses, :password_salt)

    add_index(:accesses, [:identifier], unique: true)
  end
end
