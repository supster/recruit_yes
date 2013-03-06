require 'oauth2'
require 'nokogiri'
require "uri"

class JobsController < ApplicationController 
  def index
    if session[:linkedin_token].nil?
      authorize
    else
      redirect_to new_job_path
    end
  end
  
  def new
    @job = Job.new
  end
  
  def create
    #instert into database and call LinkedIn API to display the result
    token = session[:linkedin_token]
    access_token = OAuth2::AccessToken.new(client, token, {
        :mode => :query,
        :param_name => "oauth2_access_token",
    })
    
    @query = URI.escape("https://api.linkedin.com/v1/people-search?keywords=#{params[:job][:key_words]}")
    @xml_data = access_token.get(@query)
    @xml_doc = Nokogiri::XML(@xml_data.body)
  end
  
  def show
    if params[:id] = "accept"
      accept
      redirect_to new_job_path
    end
  end
  
  API_KEY = 'kdi6s57l5zj9' #Your app's API key
  API_SECRET = 'gnwmrmh8MJeM724w' #Your app's API secret
  #REDIRECT_URI = "http://#{@env['REQUEST_URL']}/jobs/accept" #Redirect users after authentication to this path, ensure that you have set up your routes to handle the callbacks
  STATE = SecureRandom.hex(15) #A unique long string that is not easy to guess
  
  def get_redirect_uri
    if !request.port.nil? 
      local_port = ':' + request.port.to_s()
    else
      local_port = ""
    end
    "http://#{request.host}#{local_port}/jobs/accept"
  end
  
  #Instantiate your OAuth2 client object
  def client
    OAuth2::Client.new(
       API_KEY, 
       API_SECRET, 
       :authorize_url => "/uas/oauth2/authorization?response_type=code", #LinkedIn's authorization path
       :token_url => "/uas/oauth2/accessToken", #LinkedIn's access token path
       :site => "https://www.linkedin.com"
     )
  end
 
  def authorize
    #Redirect your user in order to authenticate
    redirect_to client.auth_code.authorize_url(:scope => 'r_fullprofile r_emailaddress r_network', 
                                               :state => STATE, 
                                               :redirect_uri => get_redirect_uri)
  end
 
  # This method will handle the callback once the user authorizes your application
  def accept
      #Fetch the 'code' query parameter from the callback
          code = params[:code] 
          state = params[:state]
           
          if !state.eql?(STATE)
             #Reject the request as it may be a result of CSRF
          else          
            #Get token object, passing in the authorization code from the previous step 
            token = client.auth_code.get_token(code, :redirect_uri => get_redirect_uri)
           
            #Use token object to create access token for user 
            #(this is required so that you provide the correct param name for the access token)
            access_token = OAuth2::AccessToken.new(client, token.token, {
              :mode => :query,
              :param_name => "oauth2_access_token",
              })
 
            session[:linkedin_token] = access_token.token
            #Use the access token to make an authenticated API call
            response = access_token.get('https://www.linkedin.com/v1/people/~')
 
            #Print body of response to command line window
            #logger.debug "test putting string #{response.body}"
 
            # Handle HTTP responses
            case response
              when Net::HTTPUnauthorized
                # Handle 401 Unauthorized response
              when Net::HTTPForbidden
                # Handle 403 Forbidden response
            end
        end
    end  
end
