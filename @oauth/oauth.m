classdef oauth  < sl.obj.handle_light
    %oauth  Implements Version 1 of OAuth
    %
    %   Class:
    %   oauth
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
    
    properties (Constant)
        VERSION = 1
    end
    
    properties
        credentials@oauth.creds  %Subclass of: oauth.creds
        % consumer_key
        % consumer_secret
        % token
        % token_secret
        %
        %See Also:
        %oauth.creds.public
        %oauth.creds.request
        %oauth.creds.access
        %oauth.creds.private
        
        options %Impelementation of oauth.options
        
        urlread_request     %Class oauth.urlread_request
        
        authorization_parameters %Class: oauth.params
        user_parameters          %Class: oauth.params
    end
    
    %Constructor ==========================================================
    methods (Access = protected)
        function obj = oauth(creds)
            %oauth Protected Constructor
            %
            %     See Also:
            %     oauth.request.public
            %     oauth.request.private
            %     oauth.getRequestToken
            %     oauth.getAccessToken
            
            obj.credentials = creds;
        end
    end
    
    %Request and Access Token Retrieval ===================================
    methods (Static)
        function r = getRequestToken(request_creds,request_url,varargin)
            %getRequestToken Retrieves request token info
            %
            %    r = oauth.getRequestToken(consumer_auth,request_url,varargin)
            %
            %   INPUTS
            %   ===========================================================
            %   request_creds : 
            %
            %   See Also:
            %       oauth.getAuthorizationURL

            in.options = [];
            in = sl.in.processVarargin(in,varargin);
            
            if isempty(in.options)
                in.options = oauth.options;
            end
            
            obj = oauth(request_creds);
            
            obj.options = in.options;

            obj.authorization_parameters = ...
                oauth.params.getAuthorizationParameters(obj,'request_token');
            obj.user_parameters = ...
                oauth.params.getUserParameters(obj,{});
            
            r = makeRequestHelper(obj,request_url,'GET');
        end
        function r = getAccessToken(access_token_creds,access_url,verifier,varargin)
            %
            %    r = oauth.getAccessToken(consumer_auth,request_token,request_secret,verifier,varargin)
            %
            
            in.options = [];
            in = sl.in.processVarargin(in,varargin);
            
            if isempty(in.options)
                in.options = oauth.options;
            end
            
            obj = oauth(access_token_creds);
            obj.options = in.options;
            obj.authorization_parameters = ...
                oauth.params.getAuthorizationParameters(obj,...
                'access_token','verifier',verifier);
            obj.user_parameters = ...
                oauth.params.getUserParameters(obj,{});
            
            r = makeRequestHelper(obj,access_url,'GET');
            
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
            %   INPUTS
            %   ===========================================================
            %   url         :
            %   http_method :
            %
            %   OUTPUTS
            %   ===========================================================
            %   response_obj
            
            %TODO: Ensure that the authorization and user parameters have been created
            
            %This is a bit of a hack, I really need to work out this
            %workflow
            
            opts = obj.options;
            if ~isempty(opts.extra_oauth_params)
               obj.authorization_parameters.addParams(opts.extra_oauth_params);
            end
            
            obj.urlread_request = oauth.urlread_request(url,http_method,obj.options);
            
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
    methods (Static,Hidden)
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

