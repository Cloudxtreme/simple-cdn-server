class AddDomainSizeToAccess < ActiveRecord::Migration
  def change
    add_column :accesses, :domain, :string
    add_column :accesses, :size, :integer
  end
end
