class CommentsController < ApplicationController
  before_action :validate_post_id, only: [:index, :create]
  before_action :validate_comment_id, only: [:show, :update]

  def index
  	ensure_params(:post_id) and return
  	return render_api_error(15, 400, 'error', "Post Not Found") if @post.blank?
  	@comments = Comment.where(relation_id:@post.id,relation_type: 'Post').order("created_at desc")
  end	

  def create
  	ensure_params(:post_id, :body) and return
  	return render json: {:error=>"Post Not Found"} ,status: 400  if @post.blank?
  	@comment = Comment.new(relation_id:@post.id,relation_type: 'Post', body: params[:body])
  	if @comments.save
      return render json: {:success=>"Created Successfully"} ,status: :ok
    else
    	render_api_error(15, 422, 'error', @comment.errors.full_messages.to_s)
    end  
  end

  def show
  	ensure_params(:id, :post_id) and return
  	return render json: {:error=>"Comment Not Found"} ,status: 400  if @comment.blank?
  end	

  def update
  	ensure_params(:id, :post_id, :body) and return
  	return render json: {:error=>"Comment Not Found"} ,status: 400  if @comment.blank?
  	@comment.body = params[:body]
  	if @comment.save
  		return render json: {:success=>"Updated Successfully"} ,status: :ok
  	else
    	render_api_error(15, 422, 'error', @comment.errors.full_messages.to_s)
    end 
  end	



  private

  def validate_post_id
  	@post = Post.get_post(params[:post_id])
  end	

  def validate_comment_id
  	@comment = Comment.where(relation_id:params[:post_id], id:params[:id]).first
  end

end  