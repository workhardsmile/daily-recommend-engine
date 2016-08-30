class Restaurant < ActiveRecord::Base
  self.inheritance_column = ""
  has_many :foods
  has_many :user_restaurant_configs

  def recommend_count(min_score=40)
    UserRestaurantConfig.count(:id,:conditions=>["restaurant_id=? and score >= ?", self.id, min_score])
  end

  def unrecommend_count(max_score=20)
    UserRestaurantConfig.count(:id,:conditions=>["restaurant_id=? and score <= ?", self.id, max_score])
  end

  def some_recommends(min_score=40)
    UserRestaurantConfig.find(:all, :limit=>5, :order => "score desc", :conditions=>["restaurant_id=? and score >= ?", self.id, min_score])
  end

  def some_unrecommends(max_score=20)
    UserRestaurantConfig.find(:all, :limit=>5, :order => "score asc", :conditions=>["restaurant_id=? and score <= ?", self.id, max_score])
  end
end
