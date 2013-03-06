class Job < ActiveRecord::Base
  attr_accessible :base_salary, :description, :title,
                  :desire_education, :min_education, :year,
                  :open_mind, :city, :state, :zipcode, :key_words

end
