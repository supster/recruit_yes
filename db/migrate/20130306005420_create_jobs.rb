class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string  :title
      t.integer :miles
      t.string  :city
      t.string  :state
      t.string  :zipcode
      t.string  :industry
      t.string  :description
      t.float   :year_experience
      t.string  :min_education
      t.string  :desire_education
      t.float   :base_salary
      t.string  :open_mind
      t.string  :key_words

      t.timestamps
    end
  end
end
