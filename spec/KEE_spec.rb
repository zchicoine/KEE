require_relative 'spec_helper'

RSpec.describe KEE do

    before :each do
        @kee= KEE.new
    end

    describe 'obtain all unread ships emails' do
        it 'should get all emails from the emails provided in KEE/email_server/email_connection.rb' do
             @kee.unread_emails
        end
    end
    describe 'configure email and password' do
        it 'should update the KEE/email_server/email_config.yml file' do
            cred= {email_address:'mah.sync24@gmail.com', password:'***'}
            KEE.config_connection(cred)
            credentials = YAML::load(File.read(File.expand_path('../../lib/KEE/email_server/email_config.yml', __FILE__)))['gmail']
            expect(credentials['auth_basic']['email_address']).to eq cred[:email_address]
            expect(credentials['auth_basic']['password']).to eq cred[:password]
        end
    end
end