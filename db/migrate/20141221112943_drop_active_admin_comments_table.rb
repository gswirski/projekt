class DropActiveAdminCommentsTable < ActiveRecord::Migration
  def up
    drop_table :active_admin_comments
  end
end
