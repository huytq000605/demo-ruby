class PostsController < ApplicationController
	def index
		@posts = Post.includes(:comments).all
			
		render json: @posts.to_json(include: :comments)
	end

	def create 
		@post = Post.new(params_verify)
		if @post.save
			render json: @post
		else
			render json: {message: @post.errors.full_messages }
		end
	end

	def show
		if dont_have_id
			render json: {message: "Invalid parameters"}
		end
		begin
			@post = Post.find(id: params[:id])
		rescue ActiveRecord::RecordNotFound
			return render json: {message: "Post not found"}
		end
		render json: @post
	end

	def update
		if dont_have_id
			render json: {message: "Invalid parameters"}
		end
		@post = Post.where(id: params[:id])
		if @post.update(params_verify)
			render json: @post
		else
			render json: {message: @post.errors.full_messages }
		end
	end

	def destroy
		if dont_have_id
			return render json: {message: "Invalid parameters"}
		end
		if Post.destroy(params[:id])
			render json: {message: "Success"}
		else
			render json: {message: @post.errors.full_messages }
		end
	end

	private
		def params_verify
			params.require(:post).permit(:title, :body)
		end

		def dont_have_id
			params[:id].blank? or params[:id].nil?
		end
			



end
