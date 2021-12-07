class CommentsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
		@comments = Comment.includes(:post).all
		render json: @comments
	end

	def create
		@comment = Comment.new(params_verify)
		if @comment.save
			render json: @comment
		else
			render json: {message: @comment.errors.full_messages}
		end
	end

	def show
		@comment = Comment.find(id: params[:id])
		render json: @comment
	end

	def delete
		@comment = Comment.find(id: params[:id])
		if @comment.destroy
			render json: {message: "Successful"}
		else
			render json: {message: @comment.errors.full_messages}
		end
	end

	def update
		@comment = Comment.find(id: params[:id])
		if @comment.update(params_verify)
			render json: @comment
		else
			render json: {message: @comment.errors.full_messages}
		end
	end

	private
	def params_verify
		params.require(:comment).permit(:body, :post_id)
	end
end
