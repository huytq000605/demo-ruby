class FixMemberColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :members, :lastname, :last_name
  end
end
