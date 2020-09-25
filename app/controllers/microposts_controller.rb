class MicropostsController < ApplicationController
  before_action :only_loggedin_users, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Successfully saved!"
      redirect_to root_url
    else
      @feed_items = []
      flash[:danger] = "Invalid content. Try again."
      redirect_to root_url
    end
  end

  def destroy
    Micropost.find(params[:id]).destroy
    redirect_to root_url
  end

  # Likes
  def like
    # To return to Show Page, need user ID
    # This is passed from View through hidden field
    # @user = User.find(params[:user_id])
    @micropost = Micropost.find(params[:id])
    @micropost.likes.create

    redirect_back(fallback_location: root_path)
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
