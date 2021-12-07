class PostPolicy < ApplicationPolicy
	def initialize(user, post)
		super(user)
		@post = post
	end

	def show?
		@post.name.blank?
	end
		
end