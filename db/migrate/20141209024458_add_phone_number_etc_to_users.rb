class AddPhoneNumberEtcToUsers < ActiveRecord::Migration
  def change
    add_column :users, :phone_number, :string
    add_column :users, :verification_code, :string
    add_column :users, :verified_at, :datetime
  end
end
