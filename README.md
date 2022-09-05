# ShowVis
### by Benjamin Molina

Search and share all your favorite TV Shows

This is a challenge project completed in 5 days. The APK is available in the Releases section of this project ([link](https://github.com/texocoyotl/showvis/releases/tag/20220904)).
## Challenge Goal

Create an app to retrieve shows, episodes and people information from the [TVMaze API](https://www.tvmaze.com/api).

### Mandatory Features:
  * List all of the series contained in the API used by the paging scheme provided by the API.
  * Allow users to search series by name.
  * The listing and search views must show at least the name and poster image of the
series.
  * After clicking on a series, the application should show the details of the series.
  * After clicking on an episode, the application should show the episode’s information

### Completed Bonus Features:
  * Allow the user to save a series as a favorite.
  * Allow the user to delete a series from the favorites list.
  * Allow the user to browse their favorite series in alphabetical order, and click on one to
see its details.
  * Create a people search by listing the name and image of the person.
  * After clicking on a person, the application should show the details of that person and shows related to them.
  * On a tap, the show details are shown.
  * Unit tests for main components.
  * Widget test.

## Architecture Approach

For this app, I used an architecture based on the guidelines proposed by Robert Martin about Clean Code and Clean Architecture

For references, see:
[Clean Architecture Book on Amazon](https://www.amazon.com/dp/0134494164)
[Clean Coder Website](http://cleancoder.com/products)

Based on that, I have been working in the past years with a simple interpretation, and I co-created a Flutter Library that uses the same principles I adopted on this project. Please see [Clean Framework Package](https://pub.dev/packages/clean_framework)

I took the same principles and added a simplified version with these elements:
![Clean Architecture](https://drive.google.com/uc?id=1ZrO-uazwApIIbeAPaQ5a1-thpsPxjcYn)

The goal of this approach is to have a complete control of the state of the business data and logic, which exist in a separate layer than other components that serve as interface for UI, Services, Hardware, etc.

I added brief explanations on the purpose of each component and its use as doc comments on the class itself, so please take a look at  *core/architecture_components.dart*.

## Packages and Plugins

#### Riverpod:([package](https://riverpod.dev/))
A powerful providers library that enables UseCases to be referenced without the need for a context.

#### Get It ([package](https://pub.dev/packages/get_it))
The most popular dependency injection tool at the moment.

#### Go Router ([package](https://pub.dev/packages/go_router))
A routed Navigator suggested by the Flutter Dev team.
#### Mocktail ([package](https://pub.dev/packages/mocktail))

## Improvements Roadmap

- Finish the remaining unit and widget tests to increase the coverage.
- Fix some color inconsistencies on the Dark Theme.
- Replace print calls with a logging system.
- Cache the result of API calls, since the data doesn't change often.
- Add a refresh action on the list to replace the app cache of shows.
- Refactor functionality of Shows and People app bars, the code is very similar.
- Remove responsibilities from Use Cases by making a more granular ecosystem of classes on the Dependencies layer.
- Replace hard-coded strings with internationalization support.