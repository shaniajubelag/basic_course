class StaticPagesController < ApplicationController
  def home
    # @micropost = current_user.microposts.build if logged_in?
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 12)
      # Since we're using 1 partial file (_user_info)
      # for 2 functions (Users controller & StaticPages controller)
      # & we only use 1 variable in (_user_info which is @user)
      # have logged_in?(user) && !logged_in?user ber @user
      # 
      # so if @user (!logged_in?(user)) is online, then it will pass since default is @user
      # but is current_user (logged_in?(user)) then is will also pass because we put
      # @user IS current_user, so technically, current_user is still a @user
      @user = current_user
    end
  end

  def about
  end

  def contact
  end
end
