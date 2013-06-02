classdef urlread_options < handle_light
    %
    %   Class:
    %   oauth.urlread_options
    %
    
    properties
        cast_output      = true;
        follow_redirects = true;
        read_timeout     = 10000; %If you need longer, you should know and set it as such ...
        encoding         = '';
        use_cookies      = false;
    end
    
    methods
        function s = getStruct(obj)
            msg_id = 'MATLAB:structOnObject';
            warning('off',msg_id)
            s = struct(obj);
            warning('on',msg_id)
        end
    end
    
end

