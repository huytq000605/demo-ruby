module Grape
	class Base < Grape::API
		mount Grape::Comments
	end
end