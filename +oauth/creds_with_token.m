classdef (Hidden) creds_with_token < oauth.creds
    %
    %   Class:
    %   oauth.creds_with_token
    %
    %   Extends:
    %   oauth.creds
    %
    %   See Also:
    %   oauth.creds.public
    %   oauth.creds.private
    %   oauth.creds.request
    %   oauth.creds.access
    
    properties (Abstract)
        token
        token_secret
    end
    
    methods
    end
    
end

