class PostPolicy < ApplicationPolicy
	def initialize(user, post)
		super(user)
		@post = post
	end

	def show?
		not @post.body.blank?
	end

	def update?
		@user[:role] == 'admin'
	end

	def destroy?
		@user[:role] == 'admin'
	end
		
end