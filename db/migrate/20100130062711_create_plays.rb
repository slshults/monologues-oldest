class CreatePlays < ActiveRecord::Migration
  def self.up
    create_table :plays do |t|
      t.integer :author_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :plays
  end
end
