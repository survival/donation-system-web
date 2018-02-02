# Deploying

This webapp is hosted in Heroku and uploads static assets to Amazon S3. It's using the [AWS SDK for Ruby](http://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/welcome.html) and [Heroku's Platform API](https://devcenter.heroku.com/articles/platform-api-reference) gems.


## Requirements

You will need to [download and install the Heroku CLI](https://devcenter.heroku.com/articles/heroku-command-line) for your operating system. Log in to your Heroku account and follow the prompts to create a new SSH public key.

```bash
heroku login
```

Then make sure that you have the Heroku staging and production upstreams for this webapp in your local git repository (if not, run the `scripts/setup.sh` file):

```bash
git push staging master
```


## How to deploy


Make sure that the deploy credentials are loaded and that the assets are in their latest versions:


```bash
npm run compile
cd credentials && git pull origin master && cd ..
```

Then deploy:

### To staging

```bash
. ./credentials/.deploy bundle exec rake deploy:staging
```

### To production

```bash
. ./credentials/.deploy bundle exec rake deploy:production
```

This will:
* Append a digest to `main.css` and `bundle.js` before uploading them to S3, to force browser recaching when the files change.
* upload the main styles file and the bundle JavaScript file to Amazon S3.
* deploy the site to Heroku-staging or Heroku-production

Please check `lib/config_constants.rb` for details on paths, bucket names, etc.


## Generating the right paths in the rendered views

The `href` attribute of the main styles link tag and the `src` attribute of the bundle script tag are calculated taking into account if you are in development, staging or production. The files are uploaded to different buckets so that deploying assets to staging doesn't break production.

* In DEVELOPMENT, they would point to your local versions, `css/main.css` and `js/bundle.js`.

* In STAGING:
  - bucket in AWS S3: `assets-development.survivalinternational.org`,
  - css path: `donation-system-webapp/css/DIGESTED_NAME.css`
  - js path: `donation-system-webapp/js/DIGESTED_NAME.js`

* In PRODUCTION:
  - bucket in AWS S3, `assets-production.survivalinternational.org`,
  - css path: `donation-system-webapp/css/DIGESTED_NAME.css`
  - js path: `donation-system-webapp/js/DIGESTED_NAME.js`

* In order for this to work in Heroku, the digested filenames of the files uploaded to Amazon are passed to Heroku by storing them in environment variables in Heroku staging and Heroku production.

The `donation-system-webapp` path is public in both buckets.


## Deploying problems

These examples are for staging, but the same applies for production.

* If you get:

    ```
    --------------------------------------------------------------------------
      ERRORS
    --------------------------------------------------------------------------
    Problems pushing to Heroku. Upstream and branch: staging HEAD
    --------------------------------------------------------------------------
    ```

    do:

    ```
    git push staging HEAD -f
    ```
     This happens when there is another branch pushed to staging, or when you rebased the current branch. You can also deploy to staging through the web GUI, going to [the Deploy tab in the Heroku staging app](https://dashboard.heroku.com/apps/donation-system-staging/deploy/github) and selecting the branch you want to push.

* If you get:

    ```
    --------------------------------------------------------------------------
      ERRORS
    --------------------------------------------------------------------------
    Missing AWS S3 credentials, bucket not created {:region=>"us-east-1", :access_key_id=>nil, :secret_access_key=>nil}
    Missing AWS S3 bucket or it was not created
    --------------------------------------------------------------------------
    ```

    do:

    ```bash
    cd credentials && git pull origin master && cd ..
    . ./credentials/.deploy bundle exec rake deploy:staging
    ```

    You probably forgot to run the credentials before the deploy command, or they are obsolete.

* If you get a wrongly styled or disfunctional page:

    do:
    ```bash
    npm run compile
    . ./credentials/.deploy bundle exec rake deploy:staging
    ```

    You probably forgot to produce the latest assets before deploying.

* If the styles you deployed broke the site or the functionality is broken:
    Look for the filename of the last assets that worked in AWS S3, and update the relevant environment variable in Heroku.

* If your Heroku credentials in the terminal were magically changed to the credentials of the app:

    do:
    Change to another tab in your terminal and log in again.
    You probably had the `HEROKU_PAI_KEY` loaded in your environment when you log in. To avoid that please run the deploy command as indicated, so that the credentials are applied only to that command.
