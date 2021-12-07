class CommentsController < ApplicationController
	def index
		@comments = Comment.all
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

	def delete
		@comment
	end

	private
	def params_verify
		params.require(:comment).permit(:body, :post_id)
	end
end
