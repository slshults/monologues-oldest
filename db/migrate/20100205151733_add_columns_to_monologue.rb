class AddColumnsToMonologue < ActiveRecord::Migration
  def self.up
    rename_column :monologues, :link, :pdflink
    rename_column :monologues, :name, :first_line
    rename_column :monologues, :section, :location
    add_column :monologues, :bodylink, :string
  end

  def self.down
    rename_column :monologues, :pdflink, :link
    rename_column :monologues, :firstline, :name
    rename_column :monologues, :location, :section
    remove_column :monologues, :bodylink
  end
end
