# encoding: utf-8
class RecommendRestaurant
  attr_reader :myrestaurant, :tokens, :related_level, :recommend_level, :recommend_count, :unrecommend_count, :some_recommends, :some_unrecommends, :foods, :related_restaurants
  def calculate_related_level
    if @tokens && @tokens != []
      @tokens.each do |token|
        next if token.nil?
        token.each do |key,value|
          case key
          when 'foods.name'
            @foods.each do |food|
              if food.name.include?(value)
                @related_level += 10
                food.name = food.name.gsub("#{value}","[#{value}]") unless /\[.*#{value}.*\]/.match(food.name)
              end
            end
          when 'restaurants.name'
            if @myrestaurant.name.include?(value)
              @related_level += 12
              @myrestaurant.name = @myrestaurant.name.gsub("#{value}","[#{value}]") unless /\[.*#{value}.*\]/.match(@myrestaurant.name)
            end
          when 'restaurants.type'
            if "#{@myrestaurant.type}".include?(value)
              @related_level += 8
              @myrestaurant.type = @myrestaurant.type.gsub("#{value}","[#{value}]")
            end
          when 'restaurants.address'
            if "#{@myrestaurant.address}".include?(value)
              @related_level += 5
              @myrestaurant.address = @myrestaurant.address.gsub("#{value}","[#{value}]")
            end
          when 'restaurants.comment'
            if "#{@myrestaurant.comment}".include?(value)
              @related_level += 3
              @myrestaurant.comment = @myrestaurant.comment.gsub("#{value}","[#{value}]")
            end
          end
        end
      end
    end
    @related_level = 30 if @related_level > 30
  end
  
  def update_recommned_count
    restaurant_level="#{@myrestaurant.level}"
    score_times = @myrestaurant.score_times.to_i
    if restaurant_level.include?("准二星") 
      recommned_count = score_times * 0.35
    elsif restaurant_level.include?("二星") 
      recommned_count = score_times * 0.41
    elsif restaurant_level.include?("准三星")
      recommned_count = score_times * 0.55
    elsif restaurant_level.include?("三星")
      recommned_count = score_times * 0.61
    elsif restaurant_level.include?("准四星") 
      recommned_count = score_times * 0.75
    elsif restaurant_level.include?("四星") 
      recommned_count = score_times * 0.81
    elsif restaurant_level.include?("准五星")
      recommned_count = score_times * 0.91
    elsif restaurant_level.include?("五星")
      recommned_count = score_times * 0.95
    end  
    @recommend_count = recommned_count.to_i if @recommned_count.nil? or recommned_count > @recommned_count
  end

  def calculate_recommend_level
    good_level = 0
    good_level = 15 * (@recommend_count.to_f - @unrecommend_count.to_f) / @myrestaurant.score_times.to_f if @myrestaurant.score_times.to_f > 0.0
    count_level = @myrestaurant.score_times.to_f / 100
    count_level = 15 if count_level > 15
    calculate_related_level if @related_level == 0
    @recommend_level = (good_level + count_level + @related_level.to_f).round + 10
    @recommend_level = 59 if @recommend_level > 59
  end

  def initialize(_myrestaurant,_tokens=[])
    @related_level = 0
    @myrestaurant = _myrestaurant
    @tokens = _tokens
    @unrecommend_count = myrestaurant.unrecommend_count
    @some_recommends =  myrestaurant.some_recommends
    @some_unrecommends = myrestaurant.some_unrecommends
    @foods = myrestaurant.foods
    #sql_str = "select restaurants.* from restaurants where id in(select substring(substring_index(replace(name,'#{myrestaurant.id},',''),',',-1),1) from frequent_sets on where name like '%#{myrestaurant.id}%' order by surpport_level desc limit 5) limit 5"
    sql_str = "select replace(name,',#{myrestaurant.id},',','),name from frequent_sets where name like '%,#{myrestaurant.id},%' order by surport_level desc limit 5"
    results =  ActiveRecord::Base.connection.select_rows(sql_str)
    if results && results.length>0
      columns = results.map {|result| result[0][1..-2]}
      sql_str = "select distinct restaurants.* from restaurants where restaurants.id in (#{columns.join(",")}) limit 5"
      @related_restaurants = Restaurant.find_by_sql(sql_str)
    end
    #@recommend_count = myrestaurant.recommend_count
    update_recommned_count
    calculate_recommend_level
  end
end