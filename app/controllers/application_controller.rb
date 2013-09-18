class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def client
    @client ||= FBGraph::Client.new(:client_id => '165217670339554',
                                    :secret_id => 'eccb6b09dfad16595f3aca252a85ad01' ,
                                    :token => session[:access_token])
  end
end
