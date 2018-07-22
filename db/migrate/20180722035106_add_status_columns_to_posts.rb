class AddStatusColumnsToPosts < ActiveRecord::Migration[5.1]
  def change

    add_column :posts, :exceded_vm_threshold, :boolean
    add_column :posts, :linked, :boolean

  end
end
