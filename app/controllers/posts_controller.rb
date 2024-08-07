class PostsController < ApplicationController
    def index
      @posts = Post.all.order(created_at: :desc)
      @post = Post.new
      @user = User.one
    end
  
    def create
      @post = Post.new(post_params)
      @user = User.first
      respond_to do |format|
        if @post.save
          format.html { redirect_to posts_path }
          format.turbo_stream do
            render turbo_stream: turbo_stream.prepend('posts', partial: 'posts/post', locals: { post: @post })
          end
        else
          format.html { render :index }
          format.turbo_stream { render turbo_stream: turbo_stream.replace('post_form', partial: 'posts/form', locals: { post: @post }) }
        end
      end
    end
  
    def like
      Post.find_by(id: params[:post_id]).increment(:likes_count).save
      redirect_to posts_path
    end
  
    def repost
      Post.find_by(id: params[:post_id]).increment(:repost_count).save
      redirect_to posts_path
    end
  
    private
  
    def post_params
      params.require(:post).permit(:body)
    end
end
  