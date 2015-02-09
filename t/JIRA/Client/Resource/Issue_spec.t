use strict;
use warnings;

use Test::More::Behaviour;

use Data::Dumper;

BEGIN {
    use_ok('JIRA::Client::Resource::Issue');
}

describe 'when retries disabled and expired_auth_retry off' => sub {
#    before do
#      client.retries = 0
#      client.expired_auth_retry = false
#    end
#
    it 'should not refresh tokens on 401 errors' => sub {
#      client.authorization.access_token = '12345'
#      expect(client.authorization).not_to receive(:fetch_access_token!)
#
#      @connection = stub_connection do |stub|
#        stub.get('/foo') do |env|
#          [401, {}, '{}']
#        end
#        stub.get('/foo') do |env|
#          [200, {}, '{}']
#        end
#      end
#
#      resp = client.execute(
#        :uri => 'https://www.gogole.com/foo',
#        :connection => @connection
#      )
#
#      expect(resp.response.status).to be == 401
    };

};

done_testing();
