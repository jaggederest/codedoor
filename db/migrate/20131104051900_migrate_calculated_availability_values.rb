class MigrateCalculatedAvailabilityValues < ActiveRecord::Migration
  def up
    Programmer.all.each do |programmer|
      programmer.calculate_calculated_availability
      # Do not force a successful save, as incomplete programmers are not valid
      programmer.save
    end
  end

  def down
  end
end
