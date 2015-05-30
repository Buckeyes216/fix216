class Addpublicnotetomeeting < ActiveRecord::Migration
  def change
  	add_column :meetings, :publiccomment, :string 
  end
end
