class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = Authentication.all
  end

  # POST /authentications
  # POST /authentications.json
  def create
    render :text => request.env["omniauth.auth"].to_yaml
    # @authentication = Authentication.new(authentication_params)

    # respond_to do |format|
    #   if @authentication.save
    #     format.html { redirect_to @authentication, notice: 'Authentication was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @authentication }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @authentication.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def facebook
    render :text => request.env["omniauth.auth"].to_yaml
  end

  def github
    render :text => request.env["omniauth.auth"].to_yaml
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication.destroy
    respond_to do |format|
      format.html { redirect_to authentications_url }
      format.json { head :no_content }
    end
  end

end
