# KEE

Key Element Extraction script
- Read email from Email Server (Gmail)
- categories emails to ship position, personal and not ship position
- Create array of hashes to pass to Email Recognition script

## Installation

Add this line to your application's Gemfile:

    gem 'KEE'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install KEE

## Usage

    kee = KEE.new
    
    #:return Array of emails, each email is a Hash with the following format 
    # {subject:,body:,from:,reply_to:,date:}. [] otherwise
    kee.unread_emails
    
    # :description establish a connection to a gmail account
    # see https://github.com/nfo/gmail_xoauth for more info
    # :param [option Hash] {auth_type: :basic , :email_address,:password}
    KEE.config_connection(config)


