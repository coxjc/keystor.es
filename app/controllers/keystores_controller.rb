class KeystoresController < ApplicationController
  include KeystoresHelper

  before_action :set_keystore, only: [:show, :destroy]

  # GET /keystores
  # GET /keystores.json
  def index
    @keystores = current_user.keystores
  end

  # GET /keystores/1
  # GET /keystores/1.json
  def show
    render :show
  end

  # GET /keystores/new
  def new
    @keystore = Keystore.new
  end

  # POST /keystores
  # POST /keystores.json
  def create
    file = params[:keystore][:file]
    name = params[:keystore][:name]
    url = get_s3_url file.original_filename
    obj = upload_file file, url
    respond_to do |format|
      if obj
        @keystore = Keystore.new(url: url, name: name, user:
            current_user)
        if @keystore.save
          format.html { redirect_to @keystore }
          format.json { render :show, status: :created, location: @keystore }
        else
          flash.now[:danger] = @keystore.errors.full_messages.to_sentence
          format.html { render :new }
          format.json { render json: @keystore.errors, status: :unprocessable_entity }
        end
      else
        flash.now[:danger] = 'Please ensure your file is a .keystore file.'
        format.html { render :new }
        format.json { render json: 'Improper file type', status:
            :unprocessable_entity }
      end
    end
  end

  # DELETE /keystores/1
  # DELETE /keystores/1.json
  def destroy
    delete_obj @keystore.url
    @keystore.destroy
    respond_to do |format|
      format.html { redirect_to keystores_url, notice: 'Keystore was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def upload_file(file, url)
    if file.content_type == 'application/octet-stream'
      obj = S3_BUCKET.objects[url]
      obj.write(file: file, acl: 'private')
      obj
    else
      @keystore = Keystore.new
      false
    end
  end

  def get_s3_url(filename)
    s3_url = "uploads/#{SecureRandom.uuid}/#{filename}"
    return s3_url
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_keystore
    if Keystore.find_by(:id => params[:id]) && Keystore.find_by(:id =>
                                                                    params[:id]).user_id == current_user.id
      @keystore = Keystore.find(params[:id])
    else
      flash.now[:danger] = 'Not authorized'
      redirect_to keystores_path
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def keystore_params
    params.require(:keystore).permit(:file, :name)
  end
end
