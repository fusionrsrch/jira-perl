#  JIRA REST API Perl Client

<dl>
  <dt>Homepage</dt><dd><a href="https://github.com/fusionrsrch/jira-perl">https://github.com/fusionrsrch/jira-perl</a></dd>
</dl>

## Description

This perl package provides access to the Atlassian JIRA REST API.

## Example Usage

```perl
use JIRA::Client;

my $client = JIRA::Client->new( { consumer_key => CONSUMER_KEY, consumer_secret => CONSUMER_SECRET } );

my $project = $client->project->find('SAMPLEPROJECT');

project.issues.each do |issue|
  puts "#{issue.id} - #{issue.summary}"
end

issue.comments.each {|comment| ... }

comment = issue.comments.build
comment.save({'body':'My new comment'})
comment.delete
```
