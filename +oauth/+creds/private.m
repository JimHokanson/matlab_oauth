classdef private < oauth.creds_with_token
    %
    %   Credentials needed to make a private request
    %
    %   Class:
    %   oauth.creds.private
    
    properties
       consumer_key
       consumer_secret
       token            %access_token
       token_secret     %access_token_secret
    end
    
    methods
        function obj = private(consumer_key,consumer_secret,access_token,access_token_secret)
            obj.consumer_key        = consumer_key;
            obj.consumer_secret     = consumer_secret;
            obj.token               = access_token;
            obj.token_secret        = access_token_secret;
        end
    end
    
end

