class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to Recruit Yes"
      redirect_to @user
    else
      render "new"      
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      #handle successful update
      sign_in @user
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render "edit"
    end
  end
  
  private
  
  def signed_in_user
    if signed_in? 
 
    else
      flash[:notice] = "Please sign in."
      redirect_to signin_path      
    end
  end
end
