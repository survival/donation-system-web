[![Build Status](https://travis-ci.org/survival/donation-system-webapp.svg?branch=master)](https://travis-ci.org/survival/donation-system-webapp)
[![Coverage Status](https://coveralls.io/repos/github/survival/donation-system-webapp/badge.svg?branch=master)](https://coveralls.io/github/survival/donation-system-webapp?branch=master)

# Readme

The web app for Survival's donation system.


## How to use this project


### To initialise the project

Run the setup script:

```
. scripts/setup.sh
```

This script will:
* download [the last jasmine release](https://github.com/jasmine/jasmine/releases) for the JS tests in a `temp` directory
* unzip it and copy the `lib` folder inside of the `public/javascripts/` folder
* delete the `temp` directory
* run `npm install` to install the node packages
* run `bundle install` to install gems.
* run `bundle exec rake` to run the tests.

The Jasmine setup script can also be used to update to a newer version of the library.

### To run the app locally

```bash
bundle exec rackup
```

Then visit `localhost:9292` in your browser.


### To run all tests, rubocop and npm

```bash
bundle exec rake
```


### To run one test file


```bash
bundle exec rspec path/to/test/file.rb
```


### To run one single test

```bash
bundle exec rspec path/to/test/file.rb:TESTLINENUMBER
```

### To run the JavaScript tests

Run:

```
npm test
```

and then visit:
<http://localhost:9292/javascripts/specrunner.html>


## License

[![License](https://img.shields.io/badge/mit-license-green.svg?style=flat)](https://opensource.org/licenses/mit)
MIT License
