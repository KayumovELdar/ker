class CreateRewardOwnings < ActiveRecord::Migration[6.1]
  def change
    create_table :reward_ownings do |t|
      t.references  :reward, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
