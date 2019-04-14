# News Checker

An HTTP API to check whether a given news article is fake, satirical, or real. [Here](https://news-detector.netlify.com)'s a site which uses the service. Real news is checked using [News API](https://newsapi.org).

Now you might be wondering why yet another solution was created to combat fake news. The reason is that existing solutions either use AI, or perform only basic checking. The AI solutions are plentiful, but are faulty. This is seen because FaceBook is still working on a fake news checker, and even Google hasn't been able to implement one yet. The reason being that the way AIs are currently checking the truthfulness of news is by seeing how the articles have been written. This causes for two problems. One is that only a fraction of fake news articles are written in a satirical nature, and such articles are almost always stated to be satirical (such as articles from [The Onion](https://theonion.com)); so there is little to no point of checking for the type of news in this manner. The other problem has to do with the more practical part of it-the way the user can use the application. With the AI approach, the user must manage to copy-paste the entire article's text into the service. Not only is this difficult on smaller devices like smartphones, but impractical when news sites have so many obstructions on the page which aren't easy to parse at all. This project aims to create a practical solution to combat fake news. You can check out the frontend project which utilizes this service [here](https://news-detector.netlify.com). It's a PWA, which means that you can view it on desktop, mobile devices, and even add it to your smartphone's home screen and it will run just like a native app. There's also a Google Assistant Action to make combatting fake news even easier (such as for blind people).

There are many articles backed by economic data showing that fake news played a substantial role in politics, such as [this Stanford study](https://news.stanford.edu/2017/01/18/stanford-study-examines-fake-news-2016-presidential-election/). This project will give the source of the article checked as well as similar articles found. Unlike existing fake news differentiators which only consider unchanging data sets and use poorly implemented NLP (Natural Language Processing), this is a real-time model checking the specifics. The processor will check the news article in question by ignoring insignificant words such as “a” and check against various reputed news sources to verify the exact wording. For example, [The Onion](https://www.theonion.com), a popular satirical news site, often creates articles off of real news by changing who the article whom it was written on (e.g., “Rudy Guiliani Declares: 'Truth Isn't Truth'” is real but “Rudolph Giuliani: 'Truth Isn't Truth'” is fake). A real life incident of this problem is when [Indians protested the use of Snapdeal](https://economictimes.indiatimes.com/magazines/panache/netizens-muninstall-snapdeal-app-instead-of-snapchat/articleshow/58210180.cms) because of fake news stating that Snapdeal (and not Snapchat)’s CEO had called India a “poor country”.

For example, performing a GET request to `https://fake-news-checker.herokuapp.com/api/v1/check/Elon%20Musk%20Saudi%20Autonomous%20Beheading%20Machine` gives back this response:
```json
{
  "status": "satire",
  "isReported": false,
  "news": {
    "percentage": 46,
    "matchedTitle": "Elon Musk Gives Saudi Investors Presentation On New Autonomous Beheading Machine For Adulterers",
    "source": "https://www.theonion.com/elon-musk-gives-saudi-investors-presentation-on-new-aut-1828339810"
  },
  "relatedNews": []
}
```

This project has been deprecated for the following reasons:
1. No one uses it (it's useless).
1. It's susceptible to bugs. The reason Google, Facebook, etc. still haven't been able to properly combat the problem of fake news is because even humans cannot differentiate between real and fake news. The AI way of doing it would be to analyze the way the article is written, but writing style doesn't necessarily indicate whether news is real or fake. Similarly, the way this app does it is by checking reputable sources. However, even "reputable" sources such as The New York Times constantly takes down articles they write, thereby making even their authenticity questionable.

# Documentation

The HTTP API server's base URL is `https://fake-news-checker.herokuapp.com`. This instance isn't running in production, so if you aren't using it for demonstration purposes, it is highly suggested that you deploy your own instance. If you would like to deploy your own instance or develop the project, read [these docs](docs/README.md). Below is the documentation for the HTTP API's endpoints.

### Checking The Type of News

To check what type of news `I Love My Children, But Not Enough To Make Them Corn On The Cob` is, you can make a request to `https://fake-news-checker.herokuapp.com/api/v1/check/I%20Love%20My%20Children%2C%20But%20Not%20Enough%20To%20Make%20Them%20Corn%20On%20The%20Cob`. The server would respond with:
```json
{
  "status": "real",
  "isReported": false,
  "news": {
    "percentage": 100,
    "matchedTitle": "I Love My Children, But Not Enough To Make Them Corn On The Cob",
    "source": "https://www.clickhole.com/i-love-my-children-but-not-enough-to-make-them-corn-on-1828789760",
    "snippet": "My three children are the greatest joys in my life, and raising them has given me a sense of purpose that I never knew was possible. But at a certain point, you’ve got to draw the line: I love my children, but not enough to make them corn on the cob. Read mor…"
  },
  "relatedNews": [
    {
      "percentage": 10,
      "matchedTitle": "JO WOOD, 63, admits she's 'single and ready to mingle' - but men just can't keep up with her",
      "source": "https://www.dailymail.co.uk/femail/article-6174197/JO-WOOD-63-admits-shes-single-ready-mingle-men-just-her.html",
      "snippet": "Jo Wood split up with the Rolling Stones' Ronnie Wood after he hooked up with an 18-year-old waitress in 2008. Here, she talks about how she's changed her life and is now looking for love."
    }
  ]
}
```
The `status` key can have the values `fake` (fake), `satire` (fake), `faux_satire` (looks fake, but is real), `real` (real), `unsure` (couldn't find a match), and `unavailable` (the services used for matching are currently unavailable).
The `isReported` key is a boolean stating whether the match came from the DB. If the match came from the DB, it may be incorrect since the data is from user-generated reports.

### Reporting News

You can help improve the database for checking the type of news by reporting news.

Send an HTTP POST request to `https://fake-news-checker.herokuapp.com/api/v1/report`. The `Content-Type: application/json` header should be sent along with a body such as `{"title":"Donald Trump has a brain","type":"faux_satire"}`.

The server will respond with a `204` if the title was reported successfully.

# License

This project is under the [MIT License](LICENSE).
