class PostsController < ApplicationController
  before_action :get_shark 

  def create
    @post = @shark.posts.create(post_params)
  end

  def destroy
    @post = @shark.posts.find(params[:id])
    @post.destroy   
  end

  private

  def get_shark
    @shark = Shark.find(params[:shark_id])
  end

  def post_params
    params.require(:post).permit(:body, :shark_id)
  end
end
