require_relative 'spec_helper'
require_relative '../lib/KEE/categorize_email/categorize_operation'

RSpec.describe KEE::CategorizeEmails::Operation do

    before :each do
        @operation= KEE::CategorizeEmails::Operation
    end

    describe 'Categorize an email' do
        it 'should categorize to ship email' do
            email = {subject:'',body:'mv name 123213 DWT pct ',email_address:''}
            expect(@operation.category(email)).to eq KEE::CategorizeEmails::Constants::SHIP_POSITION_EMAIL
        end
        it 'should categorize to order email' do
            email = {subject:'',body:'nype name pct DWT ',email_address:''}
            expect(@operation.category(email)).to eq KEE::CategorizeEmails::Constants::ORDERS_EMAIL
        end
        it 'should categorize to personal email' do
            email = {subject:'Re: hellow ',body:'mv pct 123213 DWT ',email_address:''}
            expect(@operation.category(email)).to eq KEE::CategorizeEmails::Constants::PERSONAL_EMAIL
        end
    end
end