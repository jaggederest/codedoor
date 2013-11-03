class AddJobAvailability < ActiveRecord::Migration
  def change
    # NOTE: The migration should prefill availability- fortunately, I'm the only developer right now!
    add_column :jobs, :availability, :string
  end
end
