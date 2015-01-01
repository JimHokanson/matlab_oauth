classdef urlread_options < handle_light
    %
    %   Class:
    %   oauth.urlread_options
    %
    %   The class is a propety of oauth.options   
    %
    %
    %   See Also:
    %   oauth.urlread_request.makeRequest
    %   oauth.options
    
    properties
        %These are options for urlread
        %-------------------------------------------------
        cast_output      = true;
        follow_redirects = true;
        read_timeout     = 10000; %If you need longer, you should know and set it as such ...
        encoding         = '';
        use_cookies      = false;
        
        %These are extras that need to be processed before calling urlread
        %:/
        %Ideally we could pass these in as options as well ...
        %------------------------------------------------------------------
        body    = ''
        headers = struct('name',{},'value',{})
        %   .name
        %   .value
    end
    
    methods
        function s = getStruct(obj)
            s = sl.obj.toStruct(obj);
            s = rmfield(s,{'body' 'headers'});
        end
    end
    
end

