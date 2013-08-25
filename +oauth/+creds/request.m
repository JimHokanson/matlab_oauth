classdef request < oauth.creds
    %
    %   Credentials needed to get a request token
    %
    %   Class:
    %   oauth.creds.request
    
    properties
       consumer_key
       consumer_secret
       token        = ''
       token_secret = ''
    end
    
    methods
        function obj = request(consumer_key,consumer_secret)
            obj.consumer_key    = consumer_key;
            obj.consumer_secret = consumer_secret;
        end
    end
    
end

