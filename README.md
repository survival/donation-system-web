[![Build Status](https://travis-ci.org/survival/donation-system-webapp.svg?branch=master)](https://travis-ci.org/survival/donation-system-webapp)
[![Coverage Status](https://coveralls.io/repos/github/survival/donation-system-webapp/badge.svg?branch=master)](https://coveralls.io/github/survival/donation-system-webapp?branch=master)
[![Dependency Status](https://gemnasium.com/badges/github.com/survival/donation-system-webapp.svg)](https://gemnasium.com/github.com/survival/donation-system-webapp)
[![Maintainability](https://api.codeclimate.com/v1/badges/16a063ba68872839c5db/maintainability)](https://codeclimate.com/github/survival/donation-system-webapp/maintainability)


# Readme

This is a web app for Survival's donation system.

This project uses the [donation system gem](https://github.com/survival/donation-system). It is recommended to read the instructions in the gem's README, in particular regarding the credentials needed to run the app.

The production credentials are stored in the server where this webapp is hosted. Both staging and production environments in that server **should have exact copies of the production credentials**. Everything else should also be the same. Production will usually deploy the master branch, while branches in PRs can be deployed to staging to test everything is working before merging the branch into master.


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


### To run all ruby tests, and rubocop

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

The default `test` task runs the server and several watch tasks for the assets. It will also watch the `views` folder and run the RSpec tests if an `erb` file changes, to ensure that changing the markup/styles/etc. doesn't break the application. Keep an eye on the terminal while developing.

We aim to keep the styles and JavaScript below 20k, since there is already some overhead of JavaScript payment libraries to download, plus custom fonts and images. Also, we try to keep accessibility in mind, and think about number of requests and file weight.

You can check the size of the bundles from time to time, typing:

```bash
ls -alh public/css/main.css public/js/bundle.js
-rwxrwxrwx 1 ubuntu ubuntu 13.0K Dec 15 15:39 public/css/main.css
-rwxrwxrwx 1 ubuntu ubuntu  2.1K Dec 15 15:39 public/js/bundle.js
```

The styles are responsive and follow the **mobile-first approach**. They are compiled and compressed using Sass. The custom fonts and images are served from Amazon S3. At the moment we are not using any JavaScript framework other than the multiple payment libraries, and ideally we should keep like that to avoid bloat.


### To run the JavaScript tests

Run the server, linter and compile tasks:

```
npm test
```

and then visit:
<http://localhost:9292/js/specrunner.html>

After executing once, this command will continue to run the server and monitor the assets for changes, and needs to be manually killed with Ctrl-C.


### To work on the syles

Run the server, linter and compile tasks:

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

Please check [the documentation on how to deploy](deploying.md).


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
