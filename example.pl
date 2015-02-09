#!/usr/bin/env perl

use strict;
use warnings;

use lib 'lib';

use JIRA::Client;

use constant CONSUMER_KEY => 'hi';
use constant CONSUMER_SECRET => 'hi';

my $client = JIRA::Client->new( { consumer_key => CONSUMER_KEY, consumer_secret => CONSUMER_SECRET } );

my $project = $client->project->find('SAMPLEPROJECT');

#project.issues.each do |issue|
#  puts "#{issue.id} - #{issue.summary}"
#end
#
#issue.comments.each {|comment| ... }
#
#comment = issue.comments.build
#comment.save({'body':'My new comment'})
#comment.delete
