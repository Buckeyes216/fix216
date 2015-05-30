class CreateAbsents < ActiveRecord::Migration
  def change
    create_table :absents do |t|

      t.timestamps
    end
  end
end
