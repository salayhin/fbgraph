require "net/http"
require "net/https"
require "cgi"
require "openssl"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  SSL_PORT = 443

  # Executes an HTTP GET request.
  # It raises a RuntimeError if the response code is not equal to 200
  def http_get host, path, params
    connection = Net::HTTP.new(host)
    process_http_response connection.request_get(path + "?" + to_query_string(params))
  end

  # Executes an HTTP POST request over SSL
  # It raises a RuntimeError if the response code is not equal to 200
  def https_post host, path, params
    https_connection host do |connection|
      connection.request_post(path, to_query_string(params))
    end
  end

  # Executes an HTTP GET request over SSL
  # It raises a RuntimeError if the response code is not equal to 200
  def https_get host, path, params, headers = nil
    https_connection host do |connection|
      connection.request_get(path + "?" + to_query_string(params), headers)
    end
  end

  def https_connection (host)
    connection = Net::HTTP.new(host, 443)
    connection.use_ssl = true
    #if ssl_ca_file
    #  connection.ca_file = ssl_ca_file
    #else
    #  logger << "No SSL ca file provided. It is highly reccomended to use one in production envinronments" if respond_to?(:logger) && logger
    #  connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #end
    process_http_response(yield(connection))
  end

  def process_http_response response
    raise response.body if response.code != "200"
    response.body
  end

  protected

  def client
    @client ||= FBGraph::Client.new(:client_id => '165217670339554',
                                    :secret_id => 'eccb6b09dfad16595f3aca252a85ad01' ,
                                    :token => session[:access_token])
  end
end
