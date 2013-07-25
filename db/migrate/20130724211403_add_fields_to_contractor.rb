class AddFieldsToContractor < ActiveRecord::Migration
  def change
    add_column :contractors, :onsite_status, :string
    add_column :contractors, :contract_to_hire, :boolean
  end
end
