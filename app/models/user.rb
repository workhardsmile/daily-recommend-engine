class User < ActiveRecord::Base
  has_many :user_restaurant_configs
end
