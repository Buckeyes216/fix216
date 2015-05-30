class CreateMotions < ActiveRecord::Migration
  def change
    create_table :motions do |t|
    	t.string :meeting
    	t.string :date
    	t.string :name
    	t.string :description
      t.timestamps
    end
  end
end
