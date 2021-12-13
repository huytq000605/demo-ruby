class AutoPublishWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
    id = args[0]
    begin
      post = Post.find_by!(id: id)
      post.published = true
      post.save!
    rescue => e
      return
    end

  end
end
