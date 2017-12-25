[![Build Status](https://travis-ci.org/survival/donation-system-webapp.svg?branch=master)](https://travis-ci.org/survival/donation-system-webapp)
[![Coverage Status](https://coveralls.io/repos/github/survival/donation-system-webapp/badge.svg?branch=master)](https://coveralls.io/github/survival/donation-system-webapp?branch=master)
[![Dependency Status](https://gemnasium.com/badges/github.com/survival/donation-system-webapp.svg)](https://gemnasium.com/github.com/survival/donation-system-webapp)
[![Maintainability](https://api.codeclimate.com/v1/badges/16a063ba68872839c5db/maintainability)](https://codeclimate.com/github/survival/donation-system-webapp/maintainability)


# Readme

The web app for Survival's donation system.


## How to use this project


## Credentials

To run this app, you need:

* The credentials listed in [the donations gem README](https://github.com/survival/donation-system#credentials). You can get them from the credentials repo, or load your own if you don't have access permissions to it.
* The deploy credentials (not really to run it but to deploy it)
* Custom Heroku credentials: donation gem credentials plus application-related credentials. For example, in staging:
```bash
DONATIONS_ENVIRONMENT="staging" # or production. Needed for the assets
MAIN_CSS_UPSTREAM_FILEPATH="donation-system-webapp/css/DIGESTED_NAME.css"
BUNDLE_JS_UPSTREAM_FILEPATH="donation-system-webapp/js/DIGESTED_NAME.js"
BUNDLE_WITHOUT="development:test:deployment" # avoid installing those gems
RACK_ENV="production"
# all the donation-system credentials
```
* Travis credentials: like Heroku. Doesn't need `BUNDLE_WITHOUT`.


### To initialise the project

Make sure that the bash scripts in the `scripts` folder have executable permissions:

```bash
chmod +x scripts/*.sh
```

Run the one-off setup script (**Beware:** Needs permissions to access the credentials repo, comment the line that sets the credentials if you don't have permissions):

```
. ./scripts/setup.sh
```

This script will:
* download [the last jasmine release](https://github.com/jasmine/jasmine/releases) for the JS tests in a `temp` directory
* unzip it and copy the `lib` folder inside of the `public/js/` folder
* delete the `temp` directory
* download the credentials
* add the Heroku remotes to your local git repository
* run `npm install` to install the node packages
* run `bundle install` to install gems.
* run `bundle exec rake` to run the tests.


### To run the app locally

```bash
bundle exec rackup
```

Then visit `localhost:9292` in your browser.


### To run all tests, and rubocop

```bash
. ./test.sh
```


### To run one test file


```bash
bundle exec rspec path/to/test/file.rb
```


### To run one single test

```bash
bundle exec rspec path/to/test/file.rb:TESTLINENUMBER
```


## Frontend

In the name of simplicity, we are using the `package.json` file as our task runner. Everything related to the frontend is there. Before installing a new module, think hard if it is really needed, and what is the simplest thing that could possibly work.

The default `test` task runs the server and several watch tasks for the assets. It will also watch the `views` folder and run the RSpec tests if an `erb` file changes, to ensure that changing the markup/styles/etc. doesn't break the application.


### To run the JavaScript tests

Run:

```
npm test
```

and then visit:
<http://localhost:9292/js/specrunner.html>

After executing once, this command will continue to run the server and monitor the assets for changes, and needs to be manually killed with Ctrl-C.


### To work on the syles

Run:

```
npm test
```

and then visit:
<http://localhost:9292>

After executing once, this command will continue to run the server and monitor the assets for changes, and needs to be manually killed with Ctrl-C.


### To compile the assets to their latest version before deploying

Run:

```
npm run compile
```

This will generate the latest version of `main.css` and `bundle.js`.


## Deploying

This webapp is hosted in Heroku and uploads static assets to Amazon S3. It's using the [AWS SDK for Ruby](http://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/welcome.html) and [Heroku's Platform API](https://devcenter.heroku.com/articles/platform-api-reference) gems.


### Requirements

You will need to [download and install the Heroku CLI](https://devcenter.heroku.com/articles/heroku-command-line) for your operating system. Log in to your Heroku account and follow the prompts to create a new SSH public key.

```bash
heroku login
```

Then make sure that you have the Heroku staging and production upstreams for this webapp in your local git repository (if not, run the `scripts/setup.sh` file):

```bash
git push staging master
```


### How to deploy

First, make sure that you have the latest assets and credentials:

```bash
npm run compile
cd credentials && git pull origin master && cd ..
```

Then deploy:

#### To staging

```bash
. ./credentials/.deploy bundle exec rake deploy:staging
```

#### To production

```bash
. ./credentials/.deploy bundle exec rake deploy:production
```

This will:
* Append a digest to `main.css` and `bundle.js` before uploading them to S3, to force browser recaching when the files change.
* upload the main styles file and the bundle JavaScript file to Amazon S3.
* deploy the site to Heroku-staging or Heroku-production

Please check `lib/config_constants.rb` for details on paths, bucket names, etc.


### Generating the right paths in the rendered views

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


### Deploying problems

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


## Updating

There are a couple things in place to keep this repository up to date:

* **Updating gems:** There is a service called "depfu" that will automatically monitor our `Gemfile.lock` and submit a PR everytime a gem is updated. This PRs should be tested and merged as they happen.
* **Updating npm modules:** Gemnasium not only provides a badge for the README informing that our gems are up to date, but also notifies of npm modules out of date.
* **Updating Jasmine:** There is no automatic notification system in place, but if a new release is out, you can update the version in the `scripts/setup_jasmine.sh` script and run it
* **Updating credentials:** They are needed to run the app, run the tests, and deploy. Please check periodically that you have the latest credentials:

```bash
cd credentials && git pull origin master && cd ..
```


## Contributing

Please check out our [Contributing guides](https://github.com/survival/contributing-guides) and our [Code of conduct](https://github.com/survival/contributing-guides/blob/master/code-of-conduct.md)


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
