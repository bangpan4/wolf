class Game < ActiveRecord::Base
	has_many :joins
	has_many :users, through: :joins
end
