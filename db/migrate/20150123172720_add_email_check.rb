class AddEmailCheck < ActiveRecord::Migration
  def up
    sql = <<-SQL
      ALTER TABLE users
        ADD CONSTRAINT check_email CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
