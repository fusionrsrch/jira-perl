#use MooseX::Declare;
#
#class JIRA::Client::Resource::Project extends JIRA::Client::Base {
package JIRA::Client::Resource::Project;

    use Mouse;

    extends 'JIRA::Client::Base';

    use Data::Dumper;

    use Method::Signatures::Simple name => 'action';
#module JIRA
#  module Resource
#
#    class ProjectFactory < JIRA::BaseFactory # :nodoc:
#    end
#
#    class Project < JIRA::Base
#
#      has_one :lead, :class => JIRA::Resource::User
#      has_many :components
#      has_many :issuetypes, :attribute_key => 'issueTypes'
#      has_many :versions
#
#      def self.key_attribute
#        :key
#      end
#
    #

    action key_attribute() {
        return 'key';
    }
#    def self.key_attribute
#        :key
#      end

    # Returns all the issues for this project
    action issues($options) {
        my $search_url = $self->client->options()->{rest_base_path} || '';
        $search_url .= '/search';
        print "JIRA::Client::Resource::Project->issues(): search_url $search_url\n";
        my $query_params = { jql => "project=\"".$self->attrs()->{key}."\"" };
        my $response = $self->client->get( $self->url_with_query_params( $search_url, $query_params) );
        my $json = $self->parse_json($response->decoded_content);
        my @issues = ();
        foreach my $issue ( @{ $json->{issues} } ) {
            push( @issues, $self->client->Issue->build($issue) );
        }
        return \@issues;
    }
#      def issues(options={})
#        search_url = client.options[:rest_base_path] + '/search'
#        query_params = {:jql => "project=\"#{key}\""}
#        query_params.update Base.query_params_for_search(options)
#        response = client.get(url_with_query_params(search_url, query_params))
#        json = self.class.parse_json(response.body)
#        json['issues'].map do |issue|
#          client.Issue.build(issue)
#        end
#      end
#    end
#  end
#end
#
#}
#1;
__PACKAGE__->meta->make_immutable();
