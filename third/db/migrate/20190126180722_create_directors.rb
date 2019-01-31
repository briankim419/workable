class CreateDirectors < ActiveRecord::Migration[5.2]
  def change
    create_table :directors do |t|
      t.string :name, null: false
      t.string :imdb_link, null: false

      t.timestamps
    end
  end
end
