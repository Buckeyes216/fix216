class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
    	t.string :name
    	t.string :group
    	t.string :description

      t.timestamps
    end
  end
end
