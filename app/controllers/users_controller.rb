class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.csv {send_data @users.to_csv}
      format.xls {send_data @users.to_csv}
    end
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

    if @user.save
      UserMailer.with(user: @user).new_user_email.deliver_now

      flash[:success] = "Thanks for Your Registration!"
      redirect_to @user
    else
      flash.now[:error] = "Please Enter the Proper Valuation."
      render :new
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
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

  def send_multiple_mail
    data = params[:body]
    subject=params[:subject]
    users = params[:emails]
    if users.present?
      users.shift()
      users.each do |email|
        UserMailer.send_bulk_email(email, subject, data).deliver_now
      end
      redirect_to root_path
    else
      messages = "Please Enter the Valid Email Address"
    end
  end

  def import
    # debugger
    User.import(params[:file])
    redirect_to root_path, notice: "Users Imported."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
