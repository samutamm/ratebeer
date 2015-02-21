class AddConfirmedToMemberships < ActiveRecord::Migration
  def up
    add_column :memberships, :confirmed, :boolean

    Membership.all.each do |membership|
      membership.update_attribute(:confirmed, true)
    end
  end

  def down
    remove_column :memberships, :confirmed
  end
end
