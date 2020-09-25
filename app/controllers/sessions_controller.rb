class SessionsController < ApplicationController
  before_action :check_signed_in, only: [:new]
  before_action :check_admin_user, only: [:admin]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "Saved successfully!"
      log_in user
      redirect_to user
    else
      render 'new'
      flash.now[:danger] = "Invalid content. Try again."
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def check_signed_in
    redirect_to(root_url) if logged_in?
  end

end