#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use JIRA::Client;
use Data::Dumper;

use constant CONSUMER_KEY => 'hi';
use constant CONSUMER_SECRET => 'hi';

my $client = JIRA::Client->new( { consumer_key => CONSUMER_KEY, consumer_secret => CONSUMER_SECRET } );

#print Dumper($client);

my $project = $client->Project->find('SAMPLEPROJECT');
#my $project = $client->Project;

#print Dumper( $project );

my $issues = $project->issues();

print Dumper( $issues );

#foreach my $issue ( @{ $project->issues() } ) {
#    print "$issue->id - $issue->summary\n";
##
##    foreach my $comment ( @{ $issue->comments() } ) {
##        print "$comment\n";
##    } 
#}
#
#my $comment = $issue->comments->build();
#$comment->save({ 'body' => 'My new comment' });
#$comment->delete();
