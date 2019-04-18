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

# [Documentation](docs/README.md)

# License

This project is under the [MIT License](LICENSE).
