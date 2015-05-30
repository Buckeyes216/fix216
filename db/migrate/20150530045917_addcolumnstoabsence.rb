class Addcolumnstoabsence < ActiveRecord::Migration
  def change
  	add_column :absents, :name, :string
  	add_column :absents, :meeting, :string
  	add_column :absents, :date, :string
  end
end
