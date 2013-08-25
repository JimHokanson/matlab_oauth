classdef public < oauth
    %
    %   Class:
    %   oauth.request.public
    
    methods
        function obj = public(public_creds)
            %public
            %
            %    obj = public(public_creds)
            %
            %    INPUTS
            %    ===========================================================
            %    public_creds : oauth.creds.public
            
            obj.consumer_authorization = public_creds;
            
        end
        function r = makeRequest(obj,url,http_method,user_parameters,options)
            %
            %
            %   r = makeRequest(obj,url,http_method,user_parameters,options)
            %
            %   INPUTS
            %   -----------------------------------------------------------
            %
            
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

