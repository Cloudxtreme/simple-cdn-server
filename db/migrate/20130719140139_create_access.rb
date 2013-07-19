class CreateAccess < ActiveRecord::Migration
  def up
    create_table :access do |t|
      t.string  :identifier
      t.string  :password
      t.string  :cdn_domain
      t.integer :quotas

      t.timestamps
    end
  end

  def down
    drop_table :access
  end
end
