# matlab_oauth #

This is an implementation of Oauth 1 for Matlab. It was originally implemented to work with the Mendeley API although it should be generic enough to work for other web services as well.

[See Jim's Mendeley API implementation in Matlab](https://github.com/JimHokanson/matlab_mendeley_api)

[See wikipedia page on oauth](http://en.wikipedia.org/wiki/OAuth)

[See list of oauth users](http://en.wikipedia.org/wiki/OAuth#List_of_OAuth_service_providers)

## Status ##

Working version finished. Code needs a bit more cleanup and documenation.

## Getting the code to work ##

1. Requires the [standard library](https://github.com/JimHokanson/matlab_standard_library)
2. Add the standard library and oauth packages to the path
3. Follow instructions below for private versus public requests

## Status ##

The basic functionality is present. Things I am still slowly working on are:

1. A more comprehensive http library. I have a lot of the code in place as functions but I want to make a class that specifically handles the requests.
2. The option handling isn't ideal. I might change this in a future release to make it less awkward to the user.
3. Documentation. This code is sadly lacking documentation and some of it may be outdated from an older version that I had written. Some of this is waiting on some Matlab documentation classes I am working on that make it much easier to document Matlab classes.
4. Token handling may eventually change to require less user handling of intermediate objects.

There are other things I would like to clean up about the code in terms of initialization order and error checking but they are lower priority for me now.

## Public Requests ##

1. Get API keys (consumer authorization) for developing apps from the service provider (Mendeley, Twitter, Netflix, etc)  
2. Use the public request object: oauth.request.public();

## Private Requests ##

1. Follow step 1 from the "Public Requests" section
2. For a particular user, get a request token so that the user can say it is alright for you to get information about them.

oauth.getRequestToken

3. Direct user to service website with your request token. This allows the service to link you (via the request token) and the user
(via credentials they subsequently provide to the web service) and
gives you the ok to work with their data. The user will generally
get a verification string (?? Mendeley only ??) to give to you for
getting an access token.

manual step, see oauth.getAuthorizationURL

4. Obtain an access token. At this point the user has agreed to
give you access to their data. You may need a verification string
from the user's authorization step.

oauth.getAccessToken

5. For future private requests (using user data) you will need to
provide the access token from step 4. In general you will not need
to repeat previous steps unless the token expires or the user takes
away your access to the account.