class CreateMoviedirectors < ActiveRecord::Migration[5.2]
  def change
    create_table :moviedirectors do |t|
      t.belongs_to :movie
      t.belongs_to :director

      t.timestamps
    end
  end
end
