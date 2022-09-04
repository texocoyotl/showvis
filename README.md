# ShowVis
## by Benjamin Molina

Search and share all your favorite TV Shows

This is a challenge project completed in 5 days, 

# Challenge Goals



# Architecture Approach

For this app, I used an architecture based on the guidelines proposed by Robert Martin about (Clean Architecture)

Please refer to this diagram
![Clean Architecture](https://drive.google.com/file/d/1ZrO-uazwApIIbeAPaQ5a1-thpsPxjcYn/view?usp=sharing)
# Improvements Roadmap

- Replace print calls with a logging system.
- Cache the result of API calls, since the data doesn't change often.
- Add a refresh action on the list to replace the app cache of shows.
- Refactor functionality of Shows and People app bars, the code is very similar.
- Remove responsibilities from Use Cases.
- Replace hard-coded strings with internationalization support.