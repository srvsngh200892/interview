class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token
  before_filter :allow_origin
  around_filter :catch_errors

  before_action :check_content_type, :authenticate_app
  skip_before_filter  :verify_authenticity_token

  respond_to :json
  def allow_origin
    response.headers['Access-Control-Allow-Origin'] = '*' if response.headers['Access-Control-Allow-Origin'].blank?
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    response.headers['Access-Control-Request-Method'] = '*'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Access-Control-Allow-Origin, X-Requested-With, Content-Type, Accept, Authorization, HTTP_ACCESS_TOKEN, ACCESS_TOKEN'
  end

  def ensure_params(*req)
    missing = []
    req.each do |param|
      if params[param].blank?
        missing << param.to_s
      end
    end
    if missing.empty?
      false
    else
      msg = "Following params are required but missing: " + missing.join(", ")
      render_api_error(11 , 400, 'params', msg) 
      true
    end
  end

  def render_api_error(code, status_code, type = 'error' , message = nil)
    error = {}
    error["code"] = code
    error["type"] = type
    error["message"] = message || APP_CONFIG["api.error"][code]
    Rails.logger.info("Rendered API error.  Request: #{request.body.read} \n Responded:\n#{{error: error, status: status_code}}")
    render json: {'error' => error}.to_json, status: status_code
  end

  def check_content_type
    if request.method == 'POST' || request.method == 'PATCH'
      unless request.content_type.present? and request.content_type.include?('application/json') 
        render_api_error(04, 400, 'request', "Only content type application/json is accepted.  Your content type: #{request.content_type}")
      end
    end
  end
  
  def authenticate_app
    keys = get_keys
    return unless keys
    app_key , app_secret = keys
    @app = AppClient.find_by_app_key(app_key)
    unless app_key && app_secret && @app && @app.status == "Active" and Devise.secure_compare(@app.app_secret, app_secret)
      render_api_error(01, 401, 'authentication') and return false 
    end
    true
  end 

  def get_keys
    keys = Base64.decode64(request.headers["HTTP_ACCESS_TOKEN"].to_s).gsub("\r\n", '').split(/:/, 4).presence
    return keys if keys and [2, 4].include? keys.length
    render_api_error(01, 401, 'authentication') and return false
  end

  def catch_errors
    yield
  rescue Exception => e
    Rails.logger.error("Unhandled API Error: #{e.to_s}.  Backtrace:\n#{e.backtrace.join("\n")}")
    Rails.logger.info("Unhandled API Error: #{e.to_s}.  Request: #{request.body.read} \n Backtrace:\n#{e.backtrace.join("\n")}")
    render_api_error(02 , 500, 'server', "API internal error: #{e.to_s}")
  end 

end
