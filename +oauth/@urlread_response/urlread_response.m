classdef urlread_response < sl.obj.handle_light
    %
    %
    %   TODO: Move this (URL processing) into it's own package
    %   See Python Requests package as a model ...
    %
    %   NOTE: The code may eventually be moved into its own package
    %   but I might still wrap it with this class to maintain
    %   my interface 
    %   
    %   Class:
    %   oauth.urlread_response
    %
    
    properties
       response
       status_value
       status_msg
    end
    
    properties (Hidden)
       raw
       extras 
    end
    
    methods
        function obj = urlread_response(response_str,extras,options)
           %
           %
           %    obj = urlread_response(response_str,extras,options)
           %
           %    See Also:
           %    oauth.makeRequestHelper
           %    oauth.urlread_request.makeRequest
            
            obj.status_value = extras.status.value;
            obj.status_msg   = extras.status.msg;
            
            if options.populate_raw
                obj.raw = response_str;
            end
            
            f = extras.firstHeaders;
            if options.parse_content_type && isfield(f,'Content_Type')
               switch lower(f.Content_Type)
                   case 'application/json'
                       obj.response = sl.io.parseJSON(response_str);
                   case 'application/x-www-form-urlencoded'
                       %oauth_callback_accepted=1&oauth_token=2b60638f8425bee5098fea00284ce0f3051ab92f3&oauth_token_secret=54a2fe1c2436f29faea687b3fcecad87&xoauth_token_ttl=3600
                       obj.response = sl.web.http.queryStringToParams(response_str);
                   otherwise
                       obj.response = response_str;
               end
            else
               obj.response = response_str;
            end
            
            obj.extras = extras;
        end
        function checkStatus(obj,value_to_match)
           if obj.status_value ~= value_to_match
              error('Status Match Error: match value %d ~=  status value %d',value_to_match,obj.status_value)
           end
        end
    end
    
end

