class UsersController < ApplicationController
  skip_before_action :authorized, :only => [:login, :create]

  def login
    if @user.nil?
      if have_email_and_password
        email = params[:email]
        password = params[:password]
        @user = User.find_by!({email: email})
        if not @user.authenticate(password)
          render json:{message: "Unauthorized"}, status: 401
          return
        end
      else
        render json:{message: "Unauthorized"}, status: 401
        return
      end
    end
    email = @user.email
    role = @user.role
    token = Auth::Jwt.encode({email: email, role: role})
    render json:{token: token}
  end

  def create
    @user = User.new(params_verify)
    @user.save!
    login
  end

  def index
    render json:User.all
  end

  private
  def params_verify
    params.require(:user).permit(:email, :password, :role)
  end

  def have_email_and_password
    if params[:email].nil? or params[:password].nil?
      return false
    end
    return true
  end
end
