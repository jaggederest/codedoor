class MonthsShouldBeIntegers < ActiveRecord::Migration
  def change
    execute <<-SQL
      ALTER TABLE resume_items ALTER COLUMN month_started TYPE integer USING(month_started::integer);
      ALTER TABLE resume_items ALTER COLUMN month_finished TYPE integer USING(month_started::integer);
    SQL

    execute <<-SQL
      ALTER TABLE education_items ALTER COLUMN month_started TYPE integer USING(month_started::integer);
      ALTER TABLE education_items ALTER COLUMN month_finished TYPE integer USING(month_finished::integer);
    SQL
  end
end
