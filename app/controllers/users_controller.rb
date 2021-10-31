class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy]
  before_action :logged_in, except: %i[ login_page recieve_login_info new create]
  before_action :match_id_profile, only: %i[ show edit update destroy]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def login_page
  	@user = User.new
  	session[:user_id] = nil
  end
  
  def recieve_login_info
  	@commit = params[:commit]
  	@loginEmail = params[:user][:email]
	@loginPassword = params[:user][:password]
  	if(@commit == 'Login')
		@usermatch = false
		@find = User.find_by(email:@loginEmail)
		if(@find && @find.authenticate(@loginPassword))
		  	redirect_to feed_path, notice: "Login successfully."
		  	@usermatch = true
		  	session[:user_id] = @find.id
		end
	  	if(@usermatch == false)
	  		redirect_to main_path, alert: "Email/Password incorrect."
	  	end
  	elsif(@commit == 'Register')
  		redirect_to new_user_path
  	end
  end
  
  def feed
	@user = User.find(session[:user_id])
	@allpost = @user.get_feed_post
  end
  
  def view_profile
	@profileName = params[:name]
	@user = User.find_by(name:@profileName)
	puts(session[:user_id])
	puts(@user.id)
	puts(Follow.find_by(follower_id: session[:user_id], followee: @user.id) == nil)
	if(@user == nil)
		redirect_to feed_path, notice: "User not found."
	end
	
  end

  def follow_info
	@commit = params[:commit]
  	@follower_id = User.find(session[:user_id]).id
  	@followee_id = params[:follow][:followee_id]
  	if(@commit == 'Follow')
  		f = Follow.create(:follower_id => @follower_id, :followee_id => @followee_id)
  	elsif(@commit == 'Unfollow')
  		Follow.find_by(follower_id: @follower_id, followee: @followee_id).destroy
  	end
  	redirect_to feed_path
  end
  
  def unfollow_info
  	
  end
  
  def likepost
  	@pid = params[:pid]
  	Like.create(post_id: @pid, likeUser: session[:user_id])
  	redirect_to feed_path, notice: "Liked!"
  end
  
  def unlikepost
  	@pid = params[:pid]
  	Like.find_by(post_id: @pid,likeUser: session[:user_id]).destroy
  	redirect_to feed_path, notice: "Unliked!"
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def logged_in
  	if(session[:user_id])
  		return true
  	else
  		redirect_to main_path, alert: "Please login!"
  	end
    end
    
    def match_id_profile
    	if(session[:user_id].to_s == params[:id])
    		return true
    	else
    		redirect_to user_path(session[:user_id]), notice: "You cannot manipulate other account(s)!"
    	end
    end
    
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
