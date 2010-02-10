class AddClassificationToPlays < ActiveRecord::Migration
  def self.up
    add_column :plays, :classification, :string
  end

  def self.down
    remove_column :plays, :classification
  end
end
