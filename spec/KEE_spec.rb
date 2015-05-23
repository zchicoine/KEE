require_relative 'spec_helper'

RSpec.describe Kee do

    before :each do
        @kee= Kee.new
    end

    describe 'obtain all unread ships emails' do
        it 'should get all emails from the emails provided in kee/email_server/email_connection.rb' do
             @kee.unread_emails
        end
        # it 'should get all emails from the emails provided in kee/email_server/email_connection.rb' do
        #     address = 'shahrad.rezaei@shah-network.com'
        #      @kee.obtain_ship_emails(address)
        # end
    end
    describe 'categorize all unread ships emails' do
        it 'should categorize all emails from shahrad.rezaei@shah-network.com' do
            address = 'shahrad.rezaei@shah-network.com'
            @kee.categorize_emails(10)
        end
    end
    describe 'configure email and password' do
        it 'should update the kee/email_server/email_config.yml file' do
            cred= {email_address:'mah.sync24@gmail.com', password:'***'}
            Kee.config_connection(cred)
            credentials = YAML::load(File.read(File.expand_path('../../lib/kee/email_server/email_config.yml', __FILE__)))['gmail']
            expect(credentials['auth_basic']['email_address']).to eq cred[:email_address]
            expect(credentials['auth_basic']['password']).to eq cred[:password]
        end
    end
end