class TemplatesController < ApplicationController
  before_action :set_template, only: %i[ show edit update destroy ]

  # GET /templates or /templates.json
  def index
    @templates = Template.all
  end

  # GET /templates/1 or /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates or /templates.json
  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to template_url(@template), notice: "Template was successfully created." }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1 or /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to template_url(@template), notice: "Template was successfully updated." }
        format.json { render :show, status: :ok, location: @template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1 or /templates/1.json
  def destroy
    @template.destroy

    respond_to do |format|
      format.html { redirect_to templates_url, notice: "Template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_template
    @template = Template.find(params[:template_id])
    subject = params[:subject]
    data = params[:body]
    users = params[:emails]
    if params[:file]
      spreadsheets = Roo::Spreadsheet.open(params[:file])
      spreadsheets.sheets.each do |spreadsheet_name|
        spreadsheet = spreadsheets.sheet(spreadsheet_name)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          user = row.to_hash.slice(*row.to_hash.keys)
          users << [user["email"],user["name"] ]
        end
      end
    end
    if users.present?
      users.compact_blank!
      # users.each do |email|
      users.each do |user_data|
        email, name = user_data
        UserMailer.send_bulk_email(email, name, subject, data).deliver_later
      end
      redirect_to root_path
    else
      messages = "Please Enter the Valid Email Address"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def template_params
      params.require(:template).permit(:subject, :body)
    end
end
