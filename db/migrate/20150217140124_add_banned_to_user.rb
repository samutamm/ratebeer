class AddBannedToUser < ActiveRecord::Migration

  def up
    add_column :users, :banned, :boolean

    User.all.each do |user|
      user.update_attribute(:banned, false)
    end
  end

  def down
    remove_column :users, :banned
  end
end
