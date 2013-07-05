classdef options < handle_light
    %
    %   Class:
    %   oauth.options
    %   
        
    properties
        signature_method           = 'HMAC-SHA1';
        http_param_encoding_option = 2; %See http_paramsToString
        %
        %
        
        %OAUTH_PARAMS RELATED
        %------------------------------------------------------------------
        %TODO: Document usage location
        allow_empty_oauth_params = true;
        cast_numbers_to_strings  = false;    %If false and #s are found, then an error occurs
        number_to_string_fhandle = @int2str; %Function used to convert #s to string
        convert_params_to_utf8   = true; 
        
        %urlread 
        %------------------------------------------------------------------
        urlread_options  %Class: oauth.urlread_options
        
        %oauth.urlread_response
        %------------------------------------------------------------------
        parse_content_type = true  %If false the content will not be parsed
        %even if a content-type is specified
        populate_raw       = true  %If false, then the hidden property
        %'raw' will not be populated (could save memory)
    end
    
    properties
        custom_authorization_generation_function_handle
        %See oauth.params.getAuthorizationParameters
    end
    
    methods
        function obj = options()
            obj.urlread_options = oauth.urlread_options;
        end
    end
    
end

