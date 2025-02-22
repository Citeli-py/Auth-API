class CreatePasswordResets < ActiveRecord::Migration[7.1]
  def change
    create_table :password_resets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token
      t.datetime :expires_at

      t.timestamps
    end
    add_index :password_resets, :token
  end
end
