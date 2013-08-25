classdef private < oauth
    %private Class for making private (user specific) oauth requests
    %
    %   Class:
    %   oauth.request.private   
    
    methods
        function obj = private(private_creds)
           %private 
           %
           %    obj = private(private_creds)
           %
           %    INPUTS
           %    =================================================
           %    private_creds
           
           obj@oauth(private_creds);
        end
        function r = makeRequest(obj,url,http_method,user_parameters,options)
           %
           %
           %    r = makeRequest(obj,url,http_method,user_parameters,options)
           %
           %    INPUTS
           %    -----------------------------------------------------------
           %    url : 
           %    method :
           %    user_parameters : 
           %    options : oauth.options

           obj.options = options;
           obj.authorization_parameters = ...
               oauth.params.getAuthorizationParameters(obj,'private');
           
           obj.user_parameters = ...
               oauth.params.getUserParameters(obj,user_parameters);
           
           r = obj.makeRequestHelper(url,http_method);
        end
        %url
    end
    
end

