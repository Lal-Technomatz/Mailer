class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.string :subject
      t.string :body

      t.timestamps
    end
  end
end
