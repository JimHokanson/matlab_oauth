classdef access < oauth.creds_with_token
    %
    %   Credentials needed to request an access token
    %
    %   Class:
    %   oauth.creds.access
    
    properties
       consumer_key
       consumer_secret
       token
       token_secret
    end
    
    methods
        function obj = access(consumer_key,consumer_secret,request_token,request_token_secret)
            obj.consumer_key         = consumer_key;
            obj.consumer_secret      = consumer_secret;
            obj.token                = request_token;
            obj.token_secret         = request_token_secret;
        end
    end
    
end

