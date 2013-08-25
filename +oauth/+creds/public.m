classdef public < oauth.creds
    %
    %   Credentials needed to make a public request
    %
    %   Class:
    %   oauth.creds.public
    
    properties
       consumer_key
       consumer_secret
    end
    
    methods
        function obj = public(consumer_key,consumer_secret)
            obj.consumer_key    = consumer_key;
            obj.consumer_secret = consumer_secret;
        end
    end
    
end

