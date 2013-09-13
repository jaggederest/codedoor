class AddProgrammerToPortfolioItems < ActiveRecord::Migration
  def change
    add_column :portfolio_items, :programmer_id, :integer
  end
end
