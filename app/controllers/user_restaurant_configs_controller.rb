class UserRestaurantConfigsController < ApplicationController
  # GET /user_restaurant_configs
  # GET /user_restaurant_configs.json
  def index
    @user_restaurant_configs = UserRestaurantConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_restaurant_configs }
    end
  end

  # GET /user_restaurant_configs/1
  # GET /user_restaurant_configs/1.json
  def show
    @user_restaurant_config = UserRestaurantConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_restaurant_config }
    end
  end

  # GET /user_restaurant_configs/new
  # GET /user_restaurant_configs/new.json
  def new
    @user_restaurant_config = UserRestaurantConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_restaurant_config }
    end
  end

  # GET /user_restaurant_configs/1/edit
  def edit
    @user_restaurant_config = UserRestaurantConfig.find(params[:id])
  end

  # POST /user_restaurant_configs
  # POST /user_restaurant_configs.json
  def create
    @user_restaurant_config = UserRestaurantConfig.new(params[:user_restaurant_config])

    respond_to do |format|
      if @user_restaurant_config.save
        format.html { redirect_to @user_restaurant_config, notice: 'User restaurant config was successfully created.' }
        format.json { render json: @user_restaurant_config, status: :created, location: @user_restaurant_config }
      else
        format.html { render action: "new" }
        format.json { render json: @user_restaurant_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_restaurant_configs/1
  # PUT /user_restaurant_configs/1.json
  def update
    @user_restaurant_config = UserRestaurantConfig.find(params[:id])

    respond_to do |format|
      if @user_restaurant_config.update_attributes(params[:user_restaurant_config])
        format.html { redirect_to @user_restaurant_config, notice: 'User restaurant config was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_restaurant_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_restaurant_configs/1
  # DELETE /user_restaurant_configs/1.json
  def destroy
    @user_restaurant_config = UserRestaurantConfig.find(params[:id])
    @user_restaurant_config.destroy

    respond_to do |format|
      format.html { redirect_to user_restaurant_configs_url }
      format.json { head :ok }
    end
  end
end
