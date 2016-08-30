class HomeController < ApplicationController
  def index
  end

  def search_result
    search_text = "" 
    search_text = params[:search_text] unless params[:search_text].nil?
    @recommends,@other_recommends = SearchKeysHelper.get_searh_results_by_user_text(search_text)
    @other_flag = false
    if @recommends.nil? or @recommends.length < 5
      @other_flag = true
      @recommends += @other_recommends[0,60-@recommends.length]
    end      
  end
end
