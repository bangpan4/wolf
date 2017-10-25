class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player_num
      t.integer :room_num

      t.timestamps null: false
    end
  end
end
