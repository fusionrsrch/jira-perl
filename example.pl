#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use JIRA::Client;
use Data::Dumper;

use constant CONSUMER_KEY => 'hi';
use constant CONSUMER_SECRET => 'hi';

#my $client = JIRA::Client->new( { consumer_key => CONSUMER_KEY, consumer_secret => CONSUMER_SECRET } );
my $client = JIRA::Client->new({ username => 'ccarpentier', password => 'net2Room!', auth_type => 'basic', site => 'https://jira.office.webassign.net'  });
#my $client = JIRA::Client->new({ username => 'ccarpentier', password => 'net2Room!', auth_type => 'basic'  });

#print Dumper($client);

my $project = $client->Project->find('CSI');

foreach my $issue ( @{ $project->issues() } ) {
    print $issue->id." - ".$issue->summary." - ".$issue->status."\n";
##
##    foreach my $comment ( @{ $issue->comments() } ) {
##        print "$comment\n";
##    } 
}
#
#my $comment = $issue->comments->build();
#$comment->save({ 'body' => 'My new comment' });
#$comment->delete();
