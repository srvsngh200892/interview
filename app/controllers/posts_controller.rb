class PostsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action      :set_post, only: :update
  ##
  # Returns a list of all posts
  #
  # GET /posts
  #
  # params: 
  #   Not Required
  def index
    @posts = Post.all
    respond_to do |format|
      format.json {render json: @posts.to_json(:except => [:created_at, :updated_at])}
    end
  end

  # GET /posts/:id
  # Returns the post with specified id

  # params: :id

  def show
    @post = Post.find_by(id: params[:id])
    respond_to do |format|
      format.json {render json: @post.to_json(:except => [:created_at, :updated_at])}
    end
  end

  def create

    @post = Post.new(post_params)
    if @post.save
      respond_to do |format|
        format.json {render json: @post.to_json(:except => [:created_at, :updated_at]), status: 201}
      end
    else
      respond_to do |format|
        format.json {render json: @post.errors, status: 422}
      end
    end
  end

  def update
    if @post.update(post_params)
      respond_to do |format|
        format.json {render json: @post.to_json(:except => [:created_at, :updated_at]), status: 200}
      end
    else
      respond_to do |format|
        format.json {render json: @post.errors, status: 422}
      end
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
  end

  def post_params
    params.permit(:title, :body)
  end

end
