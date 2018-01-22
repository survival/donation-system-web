[![Build Status](https://travis-ci.org/survival/donation-system-webapp.svg?branch=master)](https://travis-ci.org/survival/donation-system-webapp)
[![Coverage Status](https://coveralls.io/repos/github/survival/donation-system-webapp/badge.svg?branch=master)](https://coveralls.io/github/survival/donation-system-webapp?branch=master)
[![Dependency Status](https://gemnasium.com/badges/github.com/survival/donation-system-webapp.svg)](https://gemnasium.com/github.com/survival/donation-system-webapp)
[![Maintainability](https://api.codeclimate.com/v1/badges/16a063ba68872839c5db/maintainability)](https://codeclimate.com/github/survival/donation-system-webapp/maintainability)


# Readme

The web app for Survival's donation system.


## How to use this project

First clone the project:

```bash
$ git clone git@github.com:survival/donation-system-webapp.git
$ cd donation-system-webapp
```

This is a Ruby project, so you need to have Ruby installed and ideally a Ruby version manager.
You will need to tell your Ruby version manager to set your local Ruby version to the one specified in the `Gemfile`.

For example, if you are using [rbenv](https://cbednarski.com/articles/installing-ruby/):

1. Install the right Ruby version:
```bash
$ rbenv install < VERSION >
$ rbenv rehash
```
1. Move to the root directory of this project and type:
```bash
$ rbenv local < VERSION >
$ ruby -v
```

You will also need to install the `bundler` gem, which will allow you to install the rest of the dependencies listed in the `Gemfile` of this project.

```bash
$ gem install bundler
$ rbenv rehash
```


This project uses the [donation system gem](https://github.com/survival/donation-system). It is recommended to read the instructions in the gem's readme, in particular regarding the credentials needed to run the app.

The production credentials are stored in the server where this webapp is hosted. Both staging and production environments in that server **should have exact copies of the production credentials**. Everything else should also be the same. Production will usually deploy the master branch, while branches in PRs can be deployed to staging to test everything is working before merging the branch into master.


### To initialise the project

Run the one-off setup script (**Beware:** Needs permissions to access the credentials repo):

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

The Jasmine setup script can also be used to update to a newer version of the library.


### To run the app locally

```bash
bundle exec rackup
```

Then visit `localhost:9292` in your browser.


### To run all ruby tests, and rubocop

```bash
. test.sh
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

The frontend test command will also run the backend tests, to make sure we don't break anything in the backend when working on the frontend. Please keep an eye on the terminal while developing!

We aim to keep the styles and JavaScript below 20k, since there is already some overhead of JavaScript payment libraries to download, plus custom fonts and images. Also, we try to keep accessibility in mind, and think about number of requests and file weight.

You can check the size of the bundles from time to time, typing:

```bash
ls -alh public/css/main.css public/js/bundle.js
-rwxrwxrwx 1 ubuntu ubuntu 9.8K Dec 15 15:39 public/css/main.css
-rwxrwxrwx 1 ubuntu ubuntu 2.1K Dec 15 15:39 public/js/bundle.js
```


### To run the JavaScript tests

Run:

```
npm test
```

and then visit:
<http://localhost:9292/js/specrunner.html>


### To work on the syles

Run:

```
npm test
```

and then visit:
<http://localhost:9292>

The styles are responsive and follow the **mobile-first approach**. They are compiled and compressed using Sass. The custom fonts and images are served from Amazon S2.


## Deploying

This webapp is hosted in Heroku and uploads static assets to Amazon S3. It's using the [AWS SDK for Ruby](http://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/welcome.html) and [Heroku's Platform API gem](https://devcenter.heroku.com/articles/platform-api-reference).


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

To staging:

```bash
bundle exec rake deploy:staging
```

To production:

```bash
bundle exec rake deploy:production
```

This will:
* Append a timestamp to `main.css` and `bundle.js` before uploading them to S3, to force browser recaching when the files change.
* upload the main styles file and the bundle JavaScript file to Amazon S3.
* deploy the site to Heroku-staging or Heroku-production

Please check `lib/config_constants.rb` for details on paths, bucket names, etc.


### Generating the right paths in the rendered views

The `href` attribute of the main styles link tag and the `src` attribute of the bundle script tag are calculated taking into account if you are in development, staging or production. The files are uploaded to different buckets so that deploying assets to staging doesn't break production.

* In DEVELOPMENT, they would point to `css/main.css` and `js/bundle.js`.

* In STAGING:
  - bucket in AWS S3: `assets-development.survivalinternational.org`,
  - css path: `donation-system-webapp/css/main-YYY-MM-DD.css`
  - js path: `donation-system-webapp/js/bundle-YYY-MM-DD.js`

* In PRODUCTION:
  - bucket in AWS S3, `assets-production.survivalinternational.org`,
  - css path: `donation-system-webapp/css/main-YYY-MM-DD.css`
  - js path: `donation-system-webapp/js/bundle-YYY-MM-DD.js`

* In order for this to work in Heroku, the timestamped filenames of the files uploaded to Amazon are passed to Heroku by storing them in environment variables in Heroku staging and Heroku production.

The `donation-system-webapp` path is public in both buckets.


## Updating

There are a couple things in place to keep this repository up to date:

* **Updating gems:** There is a service called depfu that will automatically monitor our `Gemfile.lock` and submit a PR everytime a gem is updated. This PRs should be tested and merged as they happen.
* **Updating npm modules:** Gemnasium not only provides a badge for the README informing that our gems are up to date, but also notifies of npm modules out of date.
* **Updating Jasmine:** There is no automatic notification system in place, but if a new release is out, you just have to update the version of `scripts/setup_jasmine.sh` and run it
* **Updating credentials:** They are needed to run the app, run the tests, and deploy. Please check periodically that you have the latest credentials:

```bash
cd credentials && git pull origin master && cd ..
```


## Contributing

Please check out our [Contributing guides](https://github.com/survival/contributing-guides) and our [Code of conduct](https://github.com/survival/contributing-guides/blob/master/code-of-conduct.md)


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
