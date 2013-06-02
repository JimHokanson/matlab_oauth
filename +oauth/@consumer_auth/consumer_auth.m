classdef consumer_auth < handle_light
    %consumer_auth  Consumer authorization class
    %
    %   Class:
    %   oauth.consumer_auth
    
    properties
       key
       secret
    end
    
    methods
        function obj = consumer_auth(key,secret)
           obj.key    = key;
           obj.secret = secret;
        end
    end
    
end

