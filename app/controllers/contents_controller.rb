class ContentsController < ApplicationController

  before_filter :authenticate_user!, :except => [:index, :show, :html, :css, :update_views, :search]

  def view_user
  end

  # # GET /contents
  # # GET /contents.json
  # def index
  #   @contents = Content.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @contents }
  #   end
  # end

  # GET /contents/1
  # GET /contents/1.json
  def show
    @content = Content.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @content }
    end
  end

  def html
    @content = Content.find(params[:id])
    render :layout => false
  end

  def css
    render :text => Content.find(params[:id]).css
  end

  # GET /contents/new
  # GET /contents/new.json
  def new
    @content = Content.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @content }
    end
  end

  # GET /contents/1/edit
  def edit
    @content = Content.find(params[:id])
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(params[:content])
    @content.visible = true;
    @content.deleted = false;
    @content.views = 0;
    @content.likes = 0;
    @content.favorites = 0;
    @content.user_id = current_user.id;

    respond_to do |format|
      if @content.save
        format.html { redirect_to @content, notice: 'Content was successfully created.' }
        format.json { render json: @content, status: :created, location: @content }
      else
        format.html { render action: "new" }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contents/1
  # PUT /contents/1.json
  def update
    @content = Content.find(params[:id])

    respond_to do |format|
      if @content.update_attributes(params[:content])
        format.html { redirect_to @content }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contents/1
  # PUT /contents/1.json
  def update_views
    @content = Content.find(params[:id])

    @content.views += 1

    respond_to do |format|
      if @content.update_attributes(params[:content])
        format.html { redirect_to @content }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contents/1
  # PUT /contents/1.json
  def update_likes
    @content = Content.find(params[:id])

    if !Favorite.exists?(:content_id => @content.id, :user_id => current_user.id)
      @content.favorites += 1
      @favorites = Favorite.new
      @favorites.user_id = current_user.id
      @favorites.content_id = @content.id
      @favorites.save
    end

    respond_to do |format|
      if @content.update_attributes(params[:content])
        format.html { redirect_to @content }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content = Content.find(params[:id])
    @content.destroy

    respond_to do |format|
      format.html { redirect_to contents_url }
      format.json { head :no_content }
    end
  end

  def search
    # @contents = Content.where("title LIKE '%?%' OR description LIKE '%?%'", params[:query], params[:query])
    q = params[:query]
    # q needs to be sql-escaped, otherwise this is good to go
    @contents = Content.where("title LIKE '%#{q}%' OR description LIKE '%#{q}%'").order('favorites').reverse
  end

end
