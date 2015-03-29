#use MooseX::Declare;
#
#class JIRA::Client::Resource::IssueFactory extends JIRA::Client::BaseFactory { 
#};
#
#class JIRA::Client::Resource::Issue extends JIRA::Client::Base {
package JIRA::Client::Resource::Issue;

    use Mouse;

    extends 'JIRA::Client::Base';

    use Data::Dumper;

    use Method::Signatures::Simple name => 'action';

    has 'id'      => ( is => 'ro' );
    #has 'summary' => ( is => 'ro' );

    #before => sub {
    #     has_one('summary');
#    };

    action BUILD($args) {
        #print Dumper( $args );

        foreach my $key ( keys %{ $args } ) {
            my $value = $args->{$key};
            print "KEY: $key | $value\n";
        }
#        $self->summary('dude');
        $self->has_one('summary', { class => 'Str', nested_under => 'fields' } );
        $self->summary( $args->{summary} || '' );
        $self->has_one('reporter', { class => 'JIRA::Client::Resource::User', nested_under => 'fields' } );
        $self->has_one('assignee', { class => 'JIRA::Client::Resource::User', nested_under => 'fields' } );
        $self->has_one('project', { nested_under => 'fields' } );
        $self->has_one('issuetype', { nested_under => 'fields' } );
        $self->has_one('priority', { nested_under => 'fields' } );
        $self->has_one('status', { class => 'Hash', nested_under => 'fields' } );
        $self->status( $args->{status} );
#        $self->has_one('status');
#        $self->has_one('reporter');
    }

#
#require 'cgi'
#
#module JIRA
#  module Resource
#
#    class IssueFactory < JIRA::BaseFactory # :nodoc:
#    end
#
#    class Issue < JIRA::Base
#
#      has_one :reporter,  :class => JIRA::Resource::User,
#                          :nested_under => 'fields'
#      has_one :assignee,  :class => JIRA::Resource::User,
#                          :nested_under => 'fields'
#      has_one :project,   :nested_under => 'fields'
#
#      has_one :issuetype, :nested_under => 'fields'
#
#      has_one :priority,  :nested_under => 'fields'
#
#      has_one :status,    :nested_under => 'fields'
#
#      has_many :transitions
#
#      has_many :components, :nested_under => 'fields'
#
#      has_many :comments, :nested_under => ['fields','comment']
#
#      has_many :attachments, :nested_under => 'fields',
#                          :attribute_key => 'attachment'
#
#      has_many :versions, :nested_under => 'fields'
#
#      has_many :worklogs, :nested_under => ['fields','worklog']
#
#      def self.all(client)
#        response = client.get(
#          client.options[:rest_base_path] + "/search",
#          :expand => 'transitions.fields'
#        )
#        json = parse_json(response.body)
#        json['issues'].map do |issue|
#          client.Issue.build(issue)
#        end
#      end
#
#      def self.jql(client, jql, options = {fields: nil, start_at: nil, max_results: nil})
#        url = client.options[:rest_base_path] + "/search?jql=" + CGI.escape(jql)
#
#        url << "&fields=#{options[:fields].map{ |value| CGI.escape(value.to_s) }.join(',')}" if options[:fields]
#        url << "&startAt=#{CGI.escape(options[:start_at].to_s)}" if options[:start_at]
#        url << "&maxResults=#{CGI.escape(options[:max_results].to_s)}" if options[:max_results]
#
#        response = client.get(url)
#        json = parse_json(response.body)
#        json['issues'].map do |issue|
#          client.Issue.build(issue)
#        end
#      end
#
#      def respond_to?(method_name, include_all=false)
#        if attrs.keys.include?('fields') && attrs['fields'].keys.include?(method_name.to_s)
#          true
#        else
#          super(method_name)
#        end
#      end
#
#      def method_missing(method_name, *args, &block)
#        if attrs.keys.include?('fields') && attrs['fields'].keys.include?(method_name.to_s)
#          attrs['fields'][method_name.to_s]
#        else
#          super(method_name)
#        end
#      end
#
#    end
#
#  end
#end
#

#}
#1;

__PACKAGE__->meta->make_immutable();
