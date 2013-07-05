classdef params < oauth.handle_light
    %params
    %
    %   This class handles manipulation of oauth parameters
    %
    %   Class:
    %   oauth.params

    properties (SetAccess = protected)
        internal_parameters = {}; %(cell array) Property/Value pairs
    end
    
    properties (Hidden)
        parent %Class: oauth
    end
    
    methods (Access = private)
        function obj = params(oauth_obj)
            obj.parent = oauth_obj;
        end
    end
    
    %Initialization Methods ===============================================
    methods (Static)
        function obj = getAuthorizationParameters(oauth_obj,request_type,varargin)
            %
            %   obj = oauth.params.getAuthorizationParameters(oauth_obj,request_type,varargin)
            %
            %
            
            in.verifier = '';
            in = processVarargin(in,varargin);
            
            obj = oauth.params(oauth_obj);
            
            fh = obj.parent.options.custom_authorization_generation_function_handle;
            if ~isempty(fh)
                feval(fh,obj)
                return
            end
            
            switch request_type
                case 'private'
                    obj.internal_parameters = {...
                        'oauth_consumer_key'        obj.getConsumerKey ...
                        'oauth_token'               obj.getToken ...
                        'oauth_signature_method'    obj.getSignatureMethod ...
                        'oauth_timestamp'           obj.getTimestamp ...
                        'oauth_nonce'               obj.getNonce};
                case 'public'
                    obj.internal_parameters = {...
                        'oauth_consumer_key'        obj.getConsumerKey ...
                        'oauth_signature_method'    obj.getSignatureMethod ...
                        'oauth_timestamp'           obj.getTimestamp ...
                        'oauth_nonce'               obj.getNonce};
                case 'request_token'
                    obj.internal_parameters = {...
                        'oauth_consumer_key'        obj.getConsumerKey ...
                        'oauth_signature_method'    obj.getSignatureMethod ...
                        'oauth_timestamp'           obj.getTimestamp ...
                        'oauth_nonce'               obj.getNonce ...
                        'oauth_callback'        'oob'};
                case 'access_token'
                    obj.internal_parameters = {...
                        'oauth_consumer_key'        obj.getConsumerKey ...
                        'oauth_token'               obj.getToken ...
                        'oauth_signature_method'    obj.getSignatureMethod ...
                        'oauth_timestamp'           obj.getTimestamp ...
                        'oauth_nonce'               obj.getNonce ...
                        'oauth_verifier'            in.verifier};
            end
            
        end
        function obj = getUserParameters(oauth_obj,user_parameters__ca)
            %
            %    obj = oauth.params.getUserParameters(oauth_obj,user_parameters__ca)
            %
            
            obj = oauth.params(oauth_obj);
            obj.addParams(user_parameters__ca);
        end
    end
    
    %Parent object access methods =========================================
    methods (Hidden)
        function consumer_key = getConsumerKey(obj)
            consumer_key = obj.parent.credentials.consumer_key;
        end
        function signature_method = getSignatureMethod(obj)
            signature_method = obj.parent.options.signature_method;
        end
        function timestamp = getTimestamp(obj)
            timestamp = obj.parent.getTimestamp;
        end
        function nonce = getNonce(obj)
            nonce = obj.parent.getNonce;
        end
        function token = getToken(obj)
            token = obj.parent.credentials.token;
            if isempty(token)
                error('Request made for token, but token is empty')
            end
        end
    end

    methods
        function params = getParams(obj)
            %getParams Returns parameters of object
            %??? - who uses this, why?????
            %
            %   NOTE: The parent should use this (or really a merge)
            %   but it isn't currently ...
            params = obj.params;
        end
    end
    
    %Parameter Manipulation   =============================================
    methods (Hidden)
        function addParams(obj,paramsToAdd)
            %addParams Adds additional parameters to object
            %
            %   addParams(obj,paramsToAdd)
            %
            %   INPUT
            %   ========================================================
            %   paramsToAdd: (params type, see class definition)
            %
            %   IMPORTANT: The current implementation overrides existing
            %   values if their is property name duplication
            
            oauth.params.verifyParams(paramsToAdd,true);
            paramsToAdd = processNewParams(obj,paramsToAdd);
            
            for iAdd = 1:2:length(paramsToAdd)
                property = paramsToAdd{iAdd};
                value    = paramsToAdd{iAdd+1};
                setParameter(obj,property,value);
            end
            
        end
        function deleteParams(obj,names)
            %deleteParams Removes parameters from object
            %
            %   deleteParams(obj,names)
            %
            %   INPUTS
            %   ========================================
            %   names: names of parameters to delete
            %
            %   NOTE: This current code doesn't care about properties
            %   to be deleted that aren't present ....
            
            I = find(ismember(obj.params(1:2:end),names));
            if ~isempty(I)
                deleteIndices = 2*I;
                deleteIndices = [deleteIndices-1 deleteIndices];
                obj.params(deleteIndices) = [];
            end
        end
        function addOauthSignature(obj,value)
            %addOauthSignature Adds oauth_signature property to params
            %
            %   addOauthSignature(obj,value)
            
            setParameter(obj,'oauth_signature',value);
        end
    end
    
    methods (Hidden)
        function [str,header] = getQueryString(obj)
            %getQueryString Wrapper of http_paramsToString to produce query string
            %
            %   [str,header] = getQueryString(obj)
            %
            %   OUTPUTS
            %   =========================================
            %   str   : string to attach to URL for GET or place in body
            %           for POST
            %   header: (struct), see http_createHeader
            %
            %   PARAMETERS USED:
            %   oauth.opt_http_param_encoding_option
            %
            %   See Also:
            %   http_paramsToString
            %   oauth.make_basic_url_request
            
            %TODO: Make this local ...
            [str,header] = http_paramsToString(obj.internal_parameters,obj.parent.options.http_param_encoding_option);
        end
    end
    
    %NOTE: These functions are different from the static methods
    %as they check if the operation is desired or not ...
    methods (Hidden)
        function params = processNewParams(obj,params)
            %processNewParams Runs through all possible manipulations of new parameters
            %
            %   params = processNewParams(obj,params)
            %
            %   NOTE: This is the primary gateway for manipulation of input
            %   parameters. It calls several helper functions which do the
            %   actual work.
            %
            %   INPUT
            %   ===========================================
            %   params: see object description
            %
            %   OUTPUT
            %   ===========================================
            %   params: after possible manipulation
            %
            
            %
            %   See Also:
            %   processEmptyParams
            %   processNumericParams
            %   processUnicodeParams
            
            
            params = processEmptyParams(obj,params);
            params = processNumericParams(obj,params);
            params = processUnicodeParams(obj,params);
        end
        function params = processUnicodeParams(obj,params)
            if obj.parent.options.convert_params_to_utf8
                params = oauth.params.convertStringsToUTF8(params);
            end
        end
        function params = processEmptyParams(obj,params)
            %processEmptyParams Handles removal of empty params
            %
            %   processEmptyParams(obj)
            %
            %   Uses parent's property: opt_allow_empty_oauth_params
            %   Calls: removeEmptyParams
            if ~obj.parent.options.allow_empty_oauth_params
                params = oauth.params.removeEmptyParams(params);
            end
        end
        function params = processNumericParams(obj,params)
            %%%if ~obj.cast_numbers_to_strings, return; end
            if obj.parent.options.cast_numbers_to_strings
                params = oauth.params.convertNumbersToStrings(params,obj.parent.options.number_to_string_fhandle);
            end
        end
    end
    
    %==================================================================
    %                       STATIC METHODS
    %==================================================================
    methods (Static)
        normParams = normalizeParams(params) %External file
        function [isGood,str]  = verifyParams(params,throwError,varargin)
            %verifyParams  Verifies that parameter data is ok
            %
            %   [isGood,str]  = verifyParams(params)
            %
            %   CURRENT VERIFICATION STEPS
            %   - input data type
            %   - must be a vector
            %   - must have even length
            
            in.allow_numerics = true;
            in = processVarargin(in,varargin);
            
            
            isGood = true;
            str = '';
            if ~isempty(params)
                if in.allow_numerics
                    if ~iscellstr(params(1:2:end))
                        isGood = false;
                        str = 'Properties names are not all strings';
                    end
                else
                    if ~iscellstr(params)
                        isGood = false;
                        str = 'Input is not cellstr';
                    end
                end
                if ~isGood
                    error(str)
                else
                    return
                end
            end
            if numel(params) ~= length(params)
                isGood = false;
                str = 'Params must be a vector, not a matrix';
                if throwError
                    error(str)
                else
                    return
                end
            end
            
            if mod(length(params),2) ~= 0
                isGood = false;
                str = 'Params must come in property/value pairs';
                if throwError
                    error(str)
                else
                    return
                end
            end
        end
        function params = removeEmptyParams(params)
            %removeEmptyParams Removes empty parameters
            %
            %   paramsProcess = removeEmptyParams(paramsProcess)
            
            if isempty(params), return; end
            
            delMask  = false(1,length(params));
            for iParam = 2:2:length(params)
                if isempty(params{iParam})
                    delMask(iParam-1:iParam) = true;
                end
            end
            params(delMask) = [];
        end
        function params = convertNumbersToStrings(params,convFunction)
            %convertNumbersToStrings Convert numeric values to strings
            %
            %   paramsProcess = convertNumbersToStrings(paramsProcess,convFunction)
            %
            %   INPUTS
            %   =======================================================================
            %   paramsProcess : cell array of property/value pairs
            %   convFunction  : (function handle), function to evalute in
            %                   converting # to string
            
            
            if isempty(params), return; end
            
            assert(iscell(params),'Parameters for numeric conversion should be passed in as a cell if not empty')
            
            for iParam = 2:2:length(params)
                if isnumeric(params{iParam})
                    params{iParam} = feval(convFunction,params{iParam});
                end
            end
        end
        function params = convertStringsToUTF8(params)
            %convertStringsToUTF8 Converts all property and value strings to UTF-8
            %
            %   paramsProcess = convertStringsToUTF8(paramsProcess)
            
            params(cellfun('isclass',params,'char')) = ...
                cellfun(@(x) char(unicode2native(x)),params(cellfun('isclass',params,'char')),'un',0);
        end
        function params = fixForwardSlash(params)
            %fixForwardSlash Encodes forward slash as %2F
            %
            %   JAH TODO: Add on documentation ...
            %
            %   paramsProcess = fixForwardSlash(paramsProcess)
            %
            %
            
            for iParam = 1:length(params)
                if ischar(params{iParam})
                    params{iParam} = regexprep(params{iParam},'/','%2F');
                end
            end
        end
    end
    
    methods (Hidden, Access = private)
        function setParameter(obj,property,value)
            %setParameter Sets a parameter by either
            %
            %    params = setParameter(params,property,value)
            %
            %    Final method for adding on extra parameters
            
            %KNOWN CALLERS:
            %    addParams
            %    mergeParams
            %    addOauthSignature
            
            I = find(strcmp(obj.internal_parameters(1:2:end),property));
            if length(I) > 1
                error('Unable to update property: %s, as it occurs multiple times: %d',property,length(I))
            end
            
            if ~isempty(I)
                obj.internal_parameters{2*I} = value;
            else
                obj.internal_parameters = [obj.internal_parameters {property value}];
            end
        end
    end
    
end

