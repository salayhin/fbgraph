class OauthController < ApplicationController

  def start
    redirect_to client.authorization.authorize_url(:redirect_uri => callback_oauths_url , :scope => 'email,user_photos,friends_photos,publish_stream')
  end

  def callback
    access_token = client.authorization.process_callback(params[:code], :redirect_uri => callback_oauths_url)
    session[:access_token] = access_token
    user_json = client.selection.me.info!
    # in reality you would at this point store the access_token.token value as well as 
    # any user info you wanted
    render :json => user_json
  end

  def oclient
    OAuth2::Client.new('165217670339554','eccb6b09dfad16595f3aca252a85ad01', :site => 'https://graph.facebook.com')
  end

end