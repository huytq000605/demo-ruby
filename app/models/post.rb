class Post < ApplicationRecord
	has_many :comments
	attribute :published, :boolean, default: false

	validates :title, :body, presence: true
end
