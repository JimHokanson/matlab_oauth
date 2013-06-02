classdef private < oauth
    %
    %   Class:
    %   oauth.request.private   
    
    methods
        function obj = private(consumer_authorization,access_token,access_token_secret)
           %
           %
           %
           
           obj.consumer_authorization = consumer_authorization;
           obj.token        = access_token;
           obj.token_secret = access_token_secret;
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

