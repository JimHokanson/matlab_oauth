classdef oauth  < handle
    %oauth  Implements Version 1 of OAuth
    %
    %   Oauth outline:
    %   ===================================================================
    %   1) Get API keys (consumer authorization) for developing apps from
    %   service provider (Mendeley, Twitter, Netflix, etc)
    %   
    %   Do this online
    %
    %   For public requests this step is sufficient.
    %
    %   oauth.request.public
    %
    %   2) For a particular user, get a request token so that the user
    %   can say it is alright for you to get information about them.
    %
    %   oauth.getRequestToken
    %
    %   3) Direct user to service website with your request token. This 
    %   allows the service to link you (via the request token) and the user
    %   (via credentials they subsequently provide to the web service) and
    %   gives you the ok to work with their data. The user will generally
    %   get a verification string (?? Mendeley only ??) to give to you for
    %   getting an access token.
    %
    %   manual step, see oauth.getAuthorizationURL
    %
    %   4) Obtain an access token. At this point the user has agreed to
    %   give you access to their data. You may need a verification string
    %   from the user's authorization step.
    %
    %   oauth.getAccessToken
    %
    %   5) For future private requests (using user data) you will need to
    %   provide the access token from step 4. In general you will not need
    %   to repeat previous steps unless the token expires or the user takes
    %   away your access to the account.
    %
    %   CONSTRUCTORS
    %   ======================================================
    %   oauth.request.public
    %   oauth.request.private
    %
    %   Static methods to assist with token setup
    %   ======================================================
    %   oauth.getRequestToken
    %   oauth.getAccessToken
    
    
    %OUTSIDE DEPENDENCIES
    %--------------------------------------------------
    %   sortCellArrayRows
    %   cellArrayToString
    %   http_queryStringToParams
    %   http_paramsToQuery
    
    properties (Constant)
        VERSION = 1
    end
    
    properties
        %Constructor
        %---------------------------------------------------
        consumer_authorization   %Class: oauth.consumer_auth
        token            %(string) Optional, only needed with private request or access_token request
        token_secret     %(string) "         "
        options %Impelementation of oauth.options
        
        urlread_request     %Class oauth.urlread_request
        
        authorization_parameters %Class: oauth.params
        user_parameters          %Class: oauth.params
    end
    
    methods (Access = protected)
        function obj = oauth()
            %oauth Protected Constructor
            %
            %     See Also:
            %     oauth.request.public
            %     oauth.request.private
            %     oauth.getRequestToken
            %     oauth.getAccessToken
        end
    end
    
    methods (Static)
        function r = getRequestToken(consumer_auth,request_url,varargin)
            %getRequestToken Retrieves request token info
            %
            %    r = getRequestToken(consumer_auth,request_url,varargin)
            %
            %   See Also:
            %   oauth.getAuthorizationURL
            
            
            
            in.options = [];
            in = processVarargin(in,varargin);
            
            if isempty(in.options)
                in.options = oauth.options;
            end
            
            obj = oauth;
            obj.options = in.options;
            obj.consumer_authorization = consumer_auth;
            obj.authorization_parameters = ...
                oauth.params.getAuthorizationParameters(obj,'request_token');
            obj.user_parameters = ...
                oauth.params.getUserParameters(obj,{});
            
            r = makeRequestHelper(obj,request_url,'GET');
            %auth_url  = getAuthorizationURL(auth_url_base,request_token)
            
            %TODO: Add on link for request
            %TODO: Make this a functionS
            %urlAddress = sprintf('%s?oauth_token=%s',obj.AUTH_URL,obj.oauth_request_token);
        end
        function r = getAccessToken(consumer_auth,request_token,request_secret,verifier,varargin)
            %
            %    r = getAccessToken(consumer_auth,request_token,request_secret,verifier,varargin)
            %
            
            in.options = [];
            in = processVarargin(in,varargin);
            
            if isempty(in.options)
                in.options = oauth.options;
            end
            
            obj = oauth;
            obj.options = in.options;
            obj.token        = request_token;
            obj.token_secret = request_secret;
            obj.consumer_authorization = consumer_auth;
            obj.authorization_parameters = ...
                oauth.params.getAuthorizationParameters(obj,...
                'access_token','verifier',verifier);
            obj.user_parameters = ...
                oauth.params.getUserParameters(obj,{});
            
            r = makeRequestHelper(obj,request_url,'GET');
            
        end
    end
    
    %Signature Methods  ===================================================
    methods (Access = protected, Hidden)
        [oSignature,debugStruct] = getSignature(obj,http_method);
        baseString = createBaseString(obj)
        
        function response_obj = makeRequestHelper(obj,url,http_method)
            %
            %   response_obj = makeRequestHelper(obj,url,http_method)
            %
            
            %TODO: Ensure that the authorization and user parameters have been created
            
            obj.urlread_request = oauth.urlread_request(url,http_method,obj.options.urlread_options);
            
            %Do stuff here ....
            authorization_header = obj.sign_request;
            
            response_obj = obj.urlread_request.makeRequest(...
                obj.user_parameters,authorization_header);
            
        end
        function [authorization_header,debugStruct] = sign_request(obj)
            %sign_request Get's the Oauth signature for the request
            %
            %   sign_request(obj)
            
            if isempty(obj.authorization_parameters)
                error('Authorization parameters must be initialized before calling this function');
            end
            
            debugStruct          = obj.addSignatureToAuthorizationParams;
            authorization_header = getAuthorizationHeader(obj.authorization_parameters);
        end
    end
    
    %Static Methods =======================================================
    methods (Static)
        outputStr = percentEncodeString(inputStr,fixForwardSlash);
        
        str2      = depercentEncode(str);
        
        function auth_url  = getAuthorizationURL(auth_url_base,request_token)
            %
            %
            %   auth_url  = oauth.getAuthorizationURL(auth_url_base,request_token)
            %
            %   IMPROVEMENTS: add on copy to clipboard option
            
            auth_url = sprintf('%s?oauth_token=%s',auth_url_base,request_token);
%             if copyToClipboard
%                 clipboard('copy',auth_url)
%             end
        end
        function output = get_SHA1(data)
            %get_SHA1 Creates message digest using SHA-1 hash function
            %
            %    output = get_SHA1(data)
            
            %data = 'The quick brown fox jumps over the lazy dog';
            digest = org.apache.commons.codec.digest.DigestUtils;
            temp   = lower(dec2hex(typecast(digest.sha(data),'uint8')))';
            output = temp(:)';
            
        end
    end
    
    methods (Static, Hidden)
        function time_t = getTimestamp
            %getTimestamp Returns OAuth timestamp string
            %
            %   time_t = getTimestamp
            %
            %   OUTPUTS
            %   ===========================================================
            %   time_t: (string) Unix Time => seconds since January 1, 1970
            
            time_t = int2str((java.lang.System.currentTimeMillis)/1000);
        end
        function nonce = getNonce()
            %getNonce Returns nonce as string
            %
            %   nonce = getNonce()
            %
            %   NOTE: nonce is a random string that is used only once
            %   Implementation of this can vary ...
            
            nonce  = strrep([num2str(now) num2str(rand)], '.', '');
        end
    end
end

