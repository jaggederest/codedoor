class AddsBalancedCustomerUri < ActiveRecord::Migration
  def change
    add_column :payment_infos, :balanced_customer_uri, :string
  end
end
