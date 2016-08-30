# encoding: utf-8
module SearchKeysHelper
  require 'rubygems'
  require 'rmmseg'

  class << self
    DICT_DIR = File.join(File.dirname(__FILE__).split("app")[0],"public","private_dict")
    DICT_FILE = File.join(DICT_DIR,'my_dictionary.dic')
    Dir.mkdir DICT_DIR if not File.exist? DICT_DIR
    #ActiveRecord::Base.connection.= ActiveRecord::Base.ActiveRecord::Base.connection.ction_pool.checkout
    def load_dictionaries
      RMMSeg::Dictionary.add_dictionary(DICT_FILE,type=:words) if File.exist? DICT_FILE
      RMMSeg::Dictionary.load_dictionaries
    end

    def update_private_dictionary(str_word)
      begin
        if File.exist? DICT_FILE
          File.open(DICT_FILE,"r") do |file|
            while line = file.gets
              if line && "#{line}".include?(str_word)
              return false
              end
            end
          end
        end
        file = File.new(DICT_FILE, "w")
        file.puts "#{(str_word.length/3).to_i} #{str_word}"
        file.close
        load_dictionaries
        return true
      rescue => e
      return e
      end
    end

    def store_search_keys(result)
      date_str = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      select_sql = "select id from search_keys where name='#{result[0]}' and params='#{result[1]}' and type='#{result[2]}' and start_index=#{result[3]} and end_index=#{result[4]}"
      insert_sql = "insert into search_keys(name,params,type,start_index,end_index,created_at,updated_at) values('#{result[0]}','#{result[1]}','#{result[2]}','#{result[3]}','#{result[4]}','#{date_str}','#{date_str}')"
      results = ActiveRecord::Base.connection.select_rows(select_sql)
      if results.nil? || results.length<=0
        ActiveRecord::Base.connection.execute(insert_sql)
      end
    end

    def update_search_conditions(conditions,result)
      temp = "#{result[1]} like '%#{result[0]}%'"
      unless conditions.include?(temp)
        index = conditions.index("(#{result[1]}")
        if index && index > 0
          conditions.insert(index+1,"#{temp} or ")
        else
          if "#{result[1]}".include?(".name")
            if conditions.include?("and ((foods.name") or conditions.include?("and ((restaurants.name")
              index = conditions.index(") and")
              if index && index > 0
                conditions.insert(index+1," or (#{temp})")
              else
                conditions += " or (#{temp})"
              end
            else
              index = conditions.index("1=1")
              conditions.insert(index+3," and ((#{temp})")
            end
          elsif !conditions.include?("and (( ")
            conditions += " and (( #{temp})"
          else
            conditions += " or (#{temp})"
          end
        end
      end
      conditions
    end

    def get_search_key_results_by_name(name)
      sql_str = "select name as 'key',params,type,start_index,end_index from search_keys where name like '%#{name}%'"
      results = ActiveRecord::Base.connection.select_rows(sql_str)
    end

    def get_tokens_from_user_text(user_text)
      tokens = []
      load_dictionaries
      algor = RMMSeg::Algorithm.new(user_text)
      tok1 = algor.next_token
      pre_flag = false
      return tokens if tok1.nil?
      if "#{tok1.text}".length > 3
        results = get_search_key_results_by_name(tok1.text)
        if results && results.length>0
          results.each do |result|
            tokens.push({result[1]=>result[0]}) unless tokens.include?({result[1]=>result[0]})
          end
        end
      pre_flag = false
      else
      pre_flag = true
      end
      loop do
        tok2 = algor.next_token
        break if tok2.nil?
        if "#{tok2.text}".length > 3
          results = get_search_key_results_by_name(tok2.text)
          if results && results.length>0
            results.each do |result|
              tokens.push({result[1]=>result[0]}) unless tokens.include?({result[1]=>result[0]})
            end
          end
        pre_flag = false
        elsif pre_flag== true
          temp_sql = "select distinct concat(A.name,B.name) 'key',A.params,A.type,A.start_index,B.end_index from search_keys A inner join search_keys B on A.end_index=B.start_index and A.params=B.params where A.name='#{tok1.text}' and B.name='#{tok2.text}'"
          mresults = ActiveRecord::Base.connection.select_rows(temp_sql)
          if mresults && mresults.length>0
            mresults.each do |mresult|
              tokens.push({mresult[1]=>mresult[0]}) unless tokens.include?({mresult[1]=>mresult[0]})
              store_search_keys(mresult)
              update_private_dictionary(mresult[0])
            end
          end
        pre_flag = true
        else
        pre_flag = true
        end
        tok1 = tok2
      end
      temp = {'foods.name'=>user_text}
      tokens.insert(0,temp) unless tokens.include?(temp)
      temp = {'restaurants.name'=>user_text}
      tokens.insert(0,temp) unless tokens.include?(temp)
      return tokens
    end

    def get_search_sql_from_tokens(tokens,limit=150)
      search_sql = "select distinct restaurants.* from restaurants inner join foods on restaurants.id=foods.restaurant_id where 1<>1"
      tokens.each do |token|
        token.each do |key,value|
          temp = " or #{key} like '%#{value}%'"
          unless search_sql.include?(temp)
          search_sql += temp
          end
        end
      end
      search_sql += " order by score_times desc limit #{limit}"
    end

    def get_other_recommend_restaurants(limit=60)
      other_sql = "select distinct restaurants.* from restaurants where id in (select restaurant_id from user_restaurant_configs where score>=40 group by restaurant_id order by count(id) desc) limit #{limit}"
      other_restaurants = Restaurant.find_by_sql(other_sql)
      other_recommend_restaurants = other_restaurants.map {|other_restaurant| RecommendRestaurant.new(other_restaurant)}
    end

    def get_searh_results_by_user_text(user_text)
      tokens = get_tokens_from_user_text(user_text)
      search_sql = get_search_sql_from_tokens(tokens)
      myrestaurants = Restaurant.find_by_sql(search_sql)
      recommend_restaurants = [] 
      if myrestaurants && myrestaurants.length > 0
        recommend_restaurants = myrestaurants.map {|myrestaurant| RecommendRestaurant.new(myrestaurant,tokens)}
        recommend_restaurants = recommend_restaurants.sort_by {|recommend_restaurant| recommend_restaurant.recommend_level*-1}    
        recommend_restaurants = recommend_restaurants[0,(recommend_restaurants.length>60)?60:recommend_restaurants.length]
      end

      other_restaurants = get_other_recommend_restaurants
      other_recommend_restaurants = []
      if other_restaurants and other_restaurants.length>0
        other_recommend_restaurants = other_restaurants.sort_by {|recommend_restaurant| recommend_restaurant.recommend_level*-1}
      end
      return recommend_restaurants, other_recommend_restaurants
    end
  end
end
