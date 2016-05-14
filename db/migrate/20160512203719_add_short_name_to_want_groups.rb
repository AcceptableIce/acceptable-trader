class AddShortNameToWantGroups < ActiveRecord::Migration
  def change
    add_column :want_groups, :short_name, :string, after: :name
    add_timestamps :want_groups, null: false
  end
end
