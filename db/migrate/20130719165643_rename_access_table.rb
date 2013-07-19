class RenameAccessTable < ActiveRecord::Migration
  def up
  	rename_table('access', 'accesses')
  end

  def down
  	rename_table('accesses', 'access')
  end
end
