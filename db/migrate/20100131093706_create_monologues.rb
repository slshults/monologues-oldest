class CreateMonologues < ActiveRecord::Migration
  def self.up
    create_table :monologues do |t|
      t.integer :play_id
      t.string :section
      t.string :name
      t.text :body
      t.integer :gender_id
      t.string :character
      t.string :style
      t.string :link
      t.timestamps
    end
  end
  
  def self.down
    drop_table :monologues
  end
end
