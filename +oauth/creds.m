classdef (Hidden) creds < oauth.handle_light
    %
    %   Class:
    %   oauth.creds
    %
    %   See Also:
    %   oauth.creds_
    %   oauth.creds.public
    %   oauth.creds.private
    %   oauth.creds.request
    %   oauth.creds.access
    
    properties (Abstract)
        consumer_key
        consumer_secret
    end
    
    methods
    end
    
end

