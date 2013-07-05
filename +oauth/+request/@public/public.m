classdef public < oauth
    %
    %   Class:
    %   oauth.request.public
    
    methods
        function obj = public(consumer_authorization)
            %public
            %
            %    obj = public(consumer_authorization)
            %
            %    INPUTS
            %    ===========================================================
            %    consumer_authorization : Class: oauth.creds.public
            
            obj.consumer_authorization = consumer_authorization;
            
        end
        function r = makeRequest(obj,url,http_method,user_parameters,options)
            %
            %
            %   r = makeRequest(obj,url,http_method,user_parameters,options)
            
            obj.options = options;
            obj.authorization_parameters = ...
                oauth.params.getAuthorizationParameters(obj,'public');
            obj.user_parameters = ...
                oauth.params.getUserParameters(obj,user_parameters);
            
            r = obj.makeRequestHelper(url,http_method);
        end
        %url
    end
    
end

