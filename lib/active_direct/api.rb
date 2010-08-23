module ActiveDirect
  class Api
    def initialize(app, api_path, router_path)
      @app = app
      @api_path = api_path
      @router_path = router_path
    end

    def call(env)
      if env["PATH_INFO"].match("^#{@api_path}")
        if env["PATH_INFO"].match("^#{@api_path}.json")
          [200, { "Content-Type" => 'text/json'}, [json_api_config]]
        else
          [200, { "Content-Type" => 'text/javascript'}, [api_config]]
        end
      else
        @app.call(env)
      end
    end

    def json_api_config
      config = {
        'descriptor'=>   'REMOTING_API',
        'url'       =>   @router_path,
        'type'      =>   'remoting',
        'actions'   =>   Config.method_config,
        'namespace' =>   'App.models',
        'srv_env'   =>    RAILS_ENV
      }
      config.to_json
    end
 

    def api_config
      config = {
        'url'       =>   @router_path,
        'type'      =>   'remoting',
        'actions'   =>   Config.method_config,
        'namespace' =>   'App.models',
        'srv_env'   =>    RAILS_ENV
      }
      "REMOTING_API = #{config.to_json};"
    end
  end
end