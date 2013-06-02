# matlab_oauth #

This is an implementation of Oauth 1 for Matlab. It was originally implemented to work with the Mendeley API although it should be generic enough to work for other web services as well.

[See Jim's Mendeley API implementation in Matlab](https://github.com/JimHokanson/matlab_mendeley_api)

[See wikipedia page on oauth](http://en.wikipedia.org/wiki/OAuth)

[See list of oauth users](http://en.wikipedia.org/wiki/OAuth#List_of_OAuth_service_providers)

## Status ##

Working version finished, although code dependencies not provided (see next section).

## Getting the code to work ##

There are still some dependencies in the code which are local. I need to eventually remove them. That being said, if you are interested in using the code just send me an email and I can help you get it running.

## Status ##

The basic functionality is present. Things I am still slowly working on are:

1. A more comprehensive http library. I have a lot of the code in place as functions but I want to make a class that specifically handles the requests.
2. The option handling isn't ideal. I might change this in a future release to make it less awkward to the user.
3. Documentation. This code is sadly lacking documentation and some of it may be outdated from an older version that I had written. Some of this is waiting on some Matlab documentation classes I am working on that make it much easier to document Matlab classes.
4. Token handling may eventually change to require less user handling of intermediate objects.

There are other things I would like to clean up about the code in terms of initialization order and error checking but they are lower priority for me now.
