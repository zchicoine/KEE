# KEE

Key Element Extraction script
- Read email from Email Server (Gmail)
- categorizes emails to ship position, personal or not ship position
- Create array of hashes to pass to Email Recognition script

## Installation

Add this line to your application's Gemfile:

    gem 'KEE'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install KEE

## Usage

    KEE.unread_emails
    return Array of emails, each email is a Hash with the following format {subject:,body:,from:,reply_to:,date:}. [] otherwise

## Contributing

TODO: Write Contribution instructions here