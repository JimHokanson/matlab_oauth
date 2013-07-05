classdef urlread_request < handle_light
    %
    %
    %   Class:
    %   oauth.urlread_request
    %
    
    
    
    properties
        %Constructor
        url
        http_method
             
        oauth_options %Class: oauth.options
        %TODO: allow additional options to go here?????
    end
    
    methods
        function set.http_method(obj,value)
            obj.http_method = upper(value);
        end
    end
    
    methods
        function obj = urlread_request(url,http_method,oauth_options)
            %
            %
            %   obj = urlread_request(url,http_method,options)
            %
            %   INPUTS
            %   ===========================================================
            %   See properties ...
            
            obj.url         = url;
            obj.http_method = http_method;
            obj.oauth_options     = oauth_options;
        end
        function response = makeRequest(obj,user_parameters_obj,authorization_header)
            %
            %
            %   ?? - how to handle body input?
            
            [str,header] = user_parameters_obj.getQueryString();
            
            headers = authorization_header;
            body      = '';
            final_url = obj.url;
            %URL HANDLING
            %----------------------------------
            if strcmp(obj.http_method,'GET') && ~isempty(str)
                final_url = [final_url '?' str];
            end
            
            if strcmp(obj.http_method,'POST')
                body    = str;
                headers = [header obj.auth_header];
            end
            
            s = obj.oauth_options.urlread_options.getStruct;
            
            [output,extras] = oauth.s.urlread2(final_url,obj.http_method,body,headers,s);
            
            response = oauth.urlread_response(output,extras,obj.oauth_options);
        end
    end
    
end

