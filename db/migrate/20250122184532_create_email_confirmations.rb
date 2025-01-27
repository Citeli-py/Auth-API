class CreateEmailConfirmations < ActiveRecord::Migration[7.1]
  def change
    create_table :email_confirmations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token
      t.datetime :confirmed_at

      t.timestamps
    end
  end
end
