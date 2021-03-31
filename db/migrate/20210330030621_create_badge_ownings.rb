class CreateBadgeOwnings < ActiveRecord::Migration[6.1]
  def change
    create_table :badge_ownings do |t|
      t.references :user, null: false
      t.references :badge, null: false

      t.timestamps
    end
  end
end
