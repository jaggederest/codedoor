class AddCheckedTermsToUser < ActiveRecord::Migration
  def change
    add_column :users, :checked_terms, :boolean
  end
end
