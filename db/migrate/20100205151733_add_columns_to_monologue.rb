class AddColumnsToMonologue < ActiveRecord::Migration
  def self.up
    rename_column :monologues, :link, :pdf_link
    rename_column :monologues, :name, :first_line
    rename_column :monologues, :section, :location
    add_column :monologues, :body_link, :string
    add_column :monologues, :intercut, :integer
  end

  def self.down
    rename_column :monologues, :pdf_link, :link
    rename_column :monologues, :first_line, :name
    rename_column :monologues, :location, :section
    remove_column :monologues, :body_link
    remove_column :monologues, :intercut
  end
end
