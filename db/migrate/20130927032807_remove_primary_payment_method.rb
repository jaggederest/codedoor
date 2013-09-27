class RemovePrimaryPaymentMethod < ActiveRecord::Migration
  def change
    remove_column :payment_infos, :primary_payment_method, :string
  end
end
