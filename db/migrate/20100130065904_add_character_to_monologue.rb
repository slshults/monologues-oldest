class AddCharacterToMonologue < ActiveRecord::Migration
  def self.up
    add_column :monologues, :character, :string
    add_column :monologues, :style, :string
  end

  def self.down
    remove_column :monologues, :character
    remove_column :monologues, :style
  end
end
