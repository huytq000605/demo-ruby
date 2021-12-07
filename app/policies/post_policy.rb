class PostPolicy < ApplicationPolicy
	def initialize(super, user, post)
		super()
		@post = post