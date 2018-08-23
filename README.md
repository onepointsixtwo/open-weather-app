# Open Weather App

## The App

Hopefully the app is pretty self-explanatory, but basically you start off with a blank screen with a (+) icon in the top left corner. Clicking plus allows the user to select a location on a map, and then by clicking 'Choose location' they can view the five day forecast for that location in three hour increments. You can also add more locations if you wish. Like a very (very) simplified version of the iOS weather application. Though it has no caching / persistence abstraction layer at all, so killing the app will make these disappear again.

## Time Saving Measures

There are a number of things I have allowed in this project which I would not consider in one I was working on in a professional capacity, simply for expediency. These include, but are not limited to:

* No i18n compliant strings used

* Untested areas and largely unchanged auto-generated code used

* Dependency injection not used well - hugely simplified and not using anything similar to Swinject for cleaner DI

* No coordinators used to handle creation and management of ViewControllers and their routing

* Did not use git as I would for a real app - the commits are more like saves than properly chunked pieces of work. Largely because I was trying to be quick, and because I genuinely was using them as saves to allow me to work on the project on my two computers.

* Allowing CLLocation to be used well outside of the bounds it should instead of a custom object

* Implementation of network stack only caters for simple GET requests

* Errors all parse to a 'general' case which would be pretty unhelpful for a real REST service where you'd want to know things like the status code of the response.


## Demo

A demo of the app is below. It's a little quick and dirty, but it functions.

![Demo](https://github.com/onepointsixtwo/open-weather-app/blob/master/demo.gif)
