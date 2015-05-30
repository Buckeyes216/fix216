class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
    	t.string :name
    	t.string :description
    	t.string :date
      t.timestamps
    end
  end
end
