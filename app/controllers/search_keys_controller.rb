class SearchKeysController < ApplicationController
  # GET /search_keys
  # GET /search_keys.json
  def index
    @search_keys = SearchKey.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @search_keys }
    end
  end

  # GET /search_keys/1
  # GET /search_keys/1.json
  def show
    @search_key = SearchKey.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @search_key }
    end
  end

  # GET /search_keys/new
  # GET /search_keys/new.json
  def new
    @search_key = SearchKey.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @search_key }
    end
  end

  # GET /search_keys/1/edit
  def edit
    @search_key = SearchKey.find(params[:id])
  end

  # POST /search_keys
  # POST /search_keys.json
  def create
    @search_key = SearchKey.new(params[:search_key])

    respond_to do |format|
      if @search_key.save
        format.html { redirect_to @search_key, notice: 'Search key was successfully created.' }
        format.json { render json: @search_key, status: :created, location: @search_key }
      else
        format.html { render action: "new" }
        format.json { render json: @search_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /search_keys/1
  # PUT /search_keys/1.json
  def update
    @search_key = SearchKey.find(params[:id])

    respond_to do |format|
      if @search_key.update_attributes(params[:search_key])
        format.html { redirect_to @search_key, notice: 'Search key was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @search_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /search_keys/1
  # DELETE /search_keys/1.json
  def destroy
    @search_key = SearchKey.find(params[:id])
    @search_key.destroy

    respond_to do |format|
      format.html { redirect_to search_keys_url }
      format.json { head :ok }
    end
  end
end
