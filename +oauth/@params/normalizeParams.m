function normalized_parameters = normalizeParams(params)
%oauth_normalizeParams  Normalizes parameters for signature
%
%   Takes an input string and percent encodes it based on Section 3.4.1.3.2
%   of the Oauth Protocol
%
%   normParams = oauth_normalizeParams(params)
%
%   INPUT
%   ===========================================================
%   params : cell array of strings, NOT PERCENT ENCODED, in name,value form
%
%   OUTPUT
%   ===========================================================
%   normParams: a single string for use with base string
%
%   NOTE: the parameters 'oauth_signature' &'realm' are removed if present
%
%   See Also: 
%   sl.cellstr.join
%   sl.cellstr.joinStringPairs
%
%   IMPROVEMENTS:
%   -----------------------------------------------------------------------
%   1) Add testing suite
%
%   http://tools.ietf.org/html/rfc5849#section-3.4.1.3.2

%We won't include these in our signature string
BAD_PARAMETERS = {'oauth_signature','realm'};

CAT_STRING_1 = '=';
CAT_STRING_2 = '&';

%1) PERCENT ENCODING
params = cellfun(@oauth.percentEncodeString,params,'un',0);

%2) SORTING BY NAME THEN VALUE
params = reshape(params(:),2,length(params)/2)';
%make params in this form:
%Column 1: names
%Column 2: values
    
%NOTE: This function first sorts by the 1st column (names)
%and then sorts by the 2nd column (values)
%This takes into account situations of duplicate names
%but different values (this is possible for FORM 1)
params = sl.cellstr.sortRows(params);

names  = params(:,1);
values = params(:,2);

remove_mask         = ismember(names,BAD_PARAMETERS);
names(remove_mask)  = [];
values(remove_mask) = [];

%3) CONCATENATION OF NAME & VALUE
name_value_pairs = sl.cellstr.joinStringPairs(names,values,CAT_STRING_1);

%4) PAIR CONCATENATION
normalized_parameters = sl.cellstr.join(name_value_pairs,'d',CAT_STRING_2,'remove_empty',true); 


end


