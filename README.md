# Recipes for tumugi

This repository include sample recipes for [tumugi](https://tumugi.github.io/)

- Recipe 1: Download file and save it as localfile
  - [source](./recipes/recipe1.rb)
  - [guide](https://tumugi.github.io/recipe1/)
- Recipe 2: Export BigQuery query result to Google Drive and notify URL to Slack
  - [source](./recipes/recipe1.rb)
  - [guide](https://tumugi.github.io/recipe2/)

## How to run

### Prerquisities

- Ruby >= 2.3
- Bundler

### Setup

Copy `.env.template` to `.env` and update ENV vars to yours.

```sh
export GCP_PRIVATE_KEY_FILE="/path/to/private/key.json"
export GOOGLE_DRIVE_FOLDER_ID="YOUR_FOLDER_ID"
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/xxx"
```

Then run `bundle install` to install dependencies.

```sh
$ bundle install
```

### Run recipe

```
$ bundle exec tumugi run -f recipes/recipe1 -p day:2016-05-02 main
$ bundle exec tumugi run -f recipes/recipe2 main
```

## License

The gem is available as open source under the terms of the [Apache License
Version 2.0](http://www.apache.org/licenses/).
