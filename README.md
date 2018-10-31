## Scraping Arduino Projects

* I scraped all projects on https://create.arduino.cc/projecthub. This is a site where people can upload their amateur engineering projects that make use of Arduino, an open-source microcontroller.
* I got response data ("Respects, Views"), project info (Date, Topics), and creator info (Number of Projects, Followers).
* I tried to answer the questions of if certain topic areas receive a better ratio of Respects to Views and if the creator's followers and number of other projects affect response.
* I created a linear model to see what factors might be significant, and published a shiny app to allow the user to explore many possible models: https://create.arduino.cc/projecthub.
* I found that some topics were significant in determining Respect Ratio, though there were so many topics that these could have been coincidentally.
* Interestingly, I found no linear relationship between a creator's stats and Respect Ratio, which I did not expect.
* Im the future, I would like to spend some time transforming my data to see if I can find non-linear relationships. There is also other data that could be scraped from the site for another project, like parts needed for the project and comments of other users.
* Repo: https://github.com/mathSlug/arduinoScrape
