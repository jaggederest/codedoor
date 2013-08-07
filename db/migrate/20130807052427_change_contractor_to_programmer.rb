class ChangeContractorToProgrammer < ActiveRecord::Migration
  def change
    rename_table :contractors, :programmers
  end
end
