# Forking the Repository

1. Get a [News API key](https://newsapi.org/register).
1. Create a [Heroku account](https://signup.heroku.com).
1. Install the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli#download-and-install).
1. Create an app: `heroku create <APP_NAME>`, where `<APP_NAME>` is an optionally passed name for your app (a randomly generated one will be generated for you if you do not specify one)
1. Fork the repository.
1. In your GitLab project, go to **Settings > CI / CD**.
1. Click **Expand** on the **Variables** tab.
1. Enter the News API key.
    1. In the **Input variable key** box, enter `NEWS_API_KEY`.
    1. In the **Input variable value** box, enter your your News API key.
1. Enter your Heroku API key.
    1. In the **Input variable key** box, enter `HEROKU_API_KEY`.
    1. Get your Heroku API key.
        1. Sign in to your [Heroku dashboard](https://dashboard.heroku.com).
        1. Click your profile picture on the top right, and then click **Account settings**.
        1. In the **API Key** section, click **Reveal**.
    1. In the **Input variable value** box, enter your Heroku API key.
1. Enter your app's name. 
    1. In the **Input variable key** box, enter `APP_NAME`.
    1. In the **Input variable value** box, enter this app's name.
1. Click **Save Variables**.
