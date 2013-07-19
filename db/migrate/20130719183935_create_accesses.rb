class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.string :identifier
      t.string :password
      t.string :password_salt
      t.integer :quotas

      t.timestamps
    end
  end
end
