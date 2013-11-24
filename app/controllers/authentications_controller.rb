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

  def linkedin
    client = LinkedIn::Client.new(Rails.configuration.app_config[:linkedin]["app_id"], Rails.configuration.app_config[:linkedin]["app_secret"])
    auth = request.env["omniauth.auth"]
    # user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)

    # session[:user_id] = user.id

    # if user && !user.access_key.nil?  #also add if user with uid already exist
    #   redirect_to user_path(current_user), :notice => 'successfully signed in !'

    # else
      logger.info "---------------------in linkedin : 1"
      logger.info "http://#{request.host_with_port}/fetch/linkedin"
      logger.info "---------------------in linkedin : 1"
      request_token = client.request_token(:oauth_callback => "http://#{request.host_with_port}/fetch/linkedin")
      logger.info "----------------------inside linkedin"
      logger.info "rt : #{request_token.inspect}"
      logger.info "----------------------inside linkedin"

      session[:rtoken] = request_token.token
      session[:rsecret] = request_token.secret
      #----------------------used when I didn't knew about callback--------------------
      #session[:access_token] = request.env['omniauth.auth']['credentials']['token']
      #session[:access_secret] = request.env['omniauth.auth']['credentials']['secret']
      #client.authorize_from_access(session[:access_token], session[:access_secret])
      #--------------------------------------------------------------------------------

      redirect_to request_token.authorize_url

    # render :text => request.env["omniauth.auth"].to_yaml
  end

  def fetch_linkedin
    client = LinkedIn::Client.new(Rails.configuration.app_config[:linkedin]["app_id"], Rails.configuration.app_config[:linkedin]["app_secret"])

    pin = params[:oauth_verifier]
    atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)

    session[:pin] = pin
    session[:atoken] = atoken
    session[:asecret] = asecret

    logger.info "-------------------------fetch_linkedin"
    logger.info session[:pin]
    logger.info session[:atoken]
    logger.info session[:asecret]
    logger.info session[:rtoken]
    logger.info session[:rsecret]
    logger.info "--------------------------fetch_linkedin"
    client.authorize_from_access(session[:atoken], session[:asecret])
    #id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "connections"
    @profile = client.profile(:fields => [:id, :email_address, :headline, :industry,  :first_name, :last_name, :picture_url,:educations, :positions, :public_profile_url, :connections, :location])
    logger.info @profile
    render :text => @profile.to_yaml
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
