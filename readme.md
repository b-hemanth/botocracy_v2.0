# Botocracy
## A BERT-powered Tweet text & metadata model for authoritarian platform manipulation detection in India
***By: [Hemanth Bharatha Chakravarthy](mailto:hbharathachakravarthy@gmail.com) & [Em McGlone](mailto:mdmcglone@college.harvard.edu)***

*2 May, 2022. All errors are our own.*

## Deliverables

-   [`botocracy.PDF`](https://github.com/b-hemanth/botocracy_v2.0/blob/main/Botocracy.pdf) is the final paper deliverable. It is a self-standing document that outlines the data, wrangling, feature engineering, models tried, model evaluation, and model choice and discussion of the same. **It is our primary output.**
-   `/shiny/` is the final deliverable Shiny app. As we use a unique Python-R hybrid back-end, Shiny's default domain API does not have capacity to run this app. Hence, the app is run locally and screen recordings are submitted in `/demo/`.
-   Demo screen recording video and screeenshots are embedded below.

## File structure

-   `/data/` contains the raw data files and sampling code
-   `/shiny/` contains the Shiny app that can be run locally with included installs and the setup of a Python Conda environment via a R `reticulate` environment
-   `/paper/` contains the Rmd with the model evaluation that yields the final PDF as well as \\LaTeX style files
-   `/demo/` contains demos of the Shiny app recorded

## Demo

The Shiny App takes a Twitter username and a number of Tweets to check and returns:

1.  An overall prediction if the user is a bot and the mean bot score they attained from the tuned Random Forest model run on the important principal components of BERT word embeddings of user tweets combined with their metadata such as followers count, friends count, favorites count, number of days the account has existed, whether they have the 8-digit serial number that Twitter auto-generates for non-custom usernames, and so on.
2.  The set of requested `n` tweets from the user and the bot prediction (1 or 0) for each Tweet (based along with the relevant metadata of each tweet)

### Screen Recording

https://user-images.githubusercontent.com/43194858/166337515-cfc46112-b7b8-4abd-883d-44a433e01670.mp4


### Example 1: \@HemanthBharatha

![User: HemanthBharatha](demo/screenshots/hemanthbharatha_demo_1.png)

![User: HemanthBharatha (contd.)](demo/screenshots/hemanthbharatha_demo_2.png)

### Example 2: \@narendramodi

![User: \@narendramodi](demo/screenshots/narendramodi_demo.png)

### Example 3: a BJP fan

![User account screnshot](demo/screenshots/bjp_fan_account.png)

![User timeline sample](demo/screenshots/bjp_fan_tweets_example.png)

![BJP fan account: results](demo/screenshots/bjp_fan_demo.png)

### Example loading screen

![Loading screen demo](demo/screenshots/loading_screen_demo.png)
