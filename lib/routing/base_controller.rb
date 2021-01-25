module Routing
  class BaseController
    include Http
    
    # @param name String|Nil
    # @param action Symbol|Nil
    def initialize(name: nil, action: nil)
      @name = name
      @action = action
    end
    
    # @param request Http::Request
    # @param route_params Hash
    # @return Routing::BaseController
    def call(request, route_params)
      response = route_params.nil? ? send(action, request) : send(action, request, *route_params.values)
      response = view if !response.instance_of? Response
      response
    end
    
    # @return Routing::BaseController
    def not_found
      Response.new.not_found
    end
    
    # @return Routing::BaseController
    def internal_error
      Response.new.internal_error
    end

    protected

    # @param name String
    # @return Erb
    def view(name = "#{self.name}.#{self.action}")
      Response::view(name, binding)
    end

    # @param data Hash
    def json(data = {})
      Response::json(data)
    end

    # @param key String
    # @return String
    def environment(key)
      ENV[key]
    end
  
    private
    attr_reader :name, :action
  end
end