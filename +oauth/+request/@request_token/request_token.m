classdef request_token < oauth
    %
    %   Class:
    %   oauth.request.request_token   
    
    methods
        function obj = access_token(consumer_authorization)
           %
           %
           %
           
           obj.consumer_authorization = consumer_authorization;
           obj.token        = request_token.token;
           obj.token_secret = request_token.secret;
        end
        function r = makeRequest(obj,url,http_method,user_parameters,options)
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
