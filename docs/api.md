# API

This document explains how to use the HTTP API.

# Checking The Type of News

To check what type of news `<NEWS>` (e.g., `I Love My Children, But Not Enough To Make Them Corn On The Cob`) is, you can make a request to `<SERVER>/api/v1/check/<NEWS_ENCODED>`, where `SERVER` is the API server's URL, and `<NEWS_ENCODED>` is `<NEWS>` percent-encoded (e.g., `https://fake-news-checker.herokuapp.com/api/v1/check/I%20Love%20My%20Children%2C%20But%20Not%20Enough%20To%20Make%20Them%20Corn%20On%20The%20Cob`). An example server response is given below.

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

The `status` key can have the values `fake` (i.e., the news is satire and fake), `satire` (i.e., the news is fake), `faux_satire` (i.e., the news looks fake, but is real), `real` (i.e., the news is real), `unsure` (i.e., the server couldn't find a match), and `unavailable` (i.e., the services used for matching are currently unavailable).
The `isReported` key is a boolean stating whether the match came from the DB. If the match came from the DB, it may be incorrect since the data is from user-generated reports.

# Reporting News

You can help improve the database for checking the type of news by reporting news.

Send an HTTP POST request to `<SERVER>/api/v1/report` (e.g., `https://fake-news-checker.herokuapp.com/api/v1/report`). The `Content-Type: application/json` header should be sent along with a body such as `{"title":"Donald Trump has a brain","type":"faux_satire"}`.

The server will respond with a `204` if the title was reported successfully.