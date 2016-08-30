class FrequentSetsController < ApplicationController
  # GET /frequent_sets
  # GET /frequent_sets.json
  def index
    @frequent_sets = FrequentSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @frequent_sets }
    end
  end

  # GET /frequent_sets/1
  # GET /frequent_sets/1.json
  def show
    @frequent_set = FrequentSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @frequent_set }
    end
  end

  # GET /frequent_sets/new
  # GET /frequent_sets/new.json
  def new
    @frequent_set = FrequentSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @frequent_set }
    end
  end

  # GET /frequent_sets/1/edit
  def edit
    @frequent_set = FrequentSet.find(params[:id])
  end

  # POST /frequent_sets
  # POST /frequent_sets.json
  def create
    @frequent_set = FrequentSet.new(params[:frequent_set])

    respond_to do |format|
      if @frequent_set.save
        format.html { redirect_to @frequent_set, notice: 'Frequent set was successfully created.' }
        format.json { render json: @frequent_set, status: :created, location: @frequent_set }
      else
        format.html { render action: "new" }
        format.json { render json: @frequent_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /frequent_sets/1
  # PUT /frequent_sets/1.json
  def update
    @frequent_set = FrequentSet.find(params[:id])

    respond_to do |format|
      if @frequent_set.update_attributes(params[:frequent_set])
        format.html { redirect_to @frequent_set, notice: 'Frequent set was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @frequent_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /frequent_sets/1
  # DELETE /frequent_sets/1.json
  def destroy
    @frequent_set = FrequentSet.find(params[:id])
    @frequent_set.destroy

    respond_to do |format|
      format.html { redirect_to frequent_sets_url }
      format.json { head :ok }
    end
  end
end
