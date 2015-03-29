# ABSTRACT: A Perl JIRA REST API Client

#use MooseX::Declare;

#class JIRA::Client {
package JIRA::Client;

    use Mouse;

    use Data::Dumper;

    use JIRA::Client::Resource::Issue;
    use JIRA::Client::Resource::Project;
    use JIRA::Client::HttpClient;

    use Method::Signatures::Simple name => 'action';

    has 'request_client' => ( is => 'rw' );
    has 'options'        => ( isa => 'HashRef', is => 'rw' );

    has 'auth_type'       => ( isa => 'Str', is => 'ro', default => 'oauth' );
    has 'consumer_key'    => ( isa => 'Str', is => 'ro', default => 'consumer_key' );
    has 'consumer_secret' => ( isa => 'Str', is => 'ro', default => 'consumer_secret' );
    has 'content_path'    => ( isa => 'Str', is => 'ro', default => '/jira' );
    has 'password'        => ( isa => 'Str', is => 'ro', default => 'password' );
    has 'rest_base_path'  => ( isa => 'Str', is => 'ro', default => '/rest/api/2' );
    has 'site'            => ( isa => 'Str', is => 'ro', default => 'http://localhost:2990' );
    has 'ssl_verify_mode' => ( isa => 'Str', is => 'ro', default => 'OpenSSL::SSL::VERIFY_PEER' );
    has 'use_ssl'         => ( isa => 'Int', is => 'ro', default => 1 );
    has 'username'        => ( isa => 'Str', is => 'ro', default => 'username' );

    action BUILD() {

        my %options = ();
        foreach my $key ( qw( auth_type consumer_key consumer_secret content_path password rest_base_path site ssl_verify_mode use_ssl username ) ) {
            $options{$key} = $self->$key;
        }

        $self->options( \%options );

        if ( lc( $self->auth_type ) eq 'basic' ) {

            $self->request_client( JIRA::Client::HttpClient->new( options => $self->options ) ); 
        }
        elsif ( lc( $self->auth_type ) eq 'oauth' ) {

            #$self->request_client( JIRA::Client::HttpClient->new( options => $self->options ) );
        }
        else {
        }
    }

    action Project {
        return JIRA::Client::Resource::Project->new( client => $self );
    } 

    action Issue {
        return JIRA::Client::Resource::Issue->new( client => $self );
    }

    action get($path, $headers) {
        return $self->request( 'get', $path, undef, $self->_merge_default_headers( $headers ) );
    }

    # Sends the specified HTTP request to the REST API through the
    # appropriate method (oauth, basic).
    action request($http_method, $path, $body, $headers) {
        return $self->request_client->request({ args => { http_method => $http_method, path => $path, body => $body, headers => $headers } });
    }







    


#sub get_issue {
#    my ( $self, $issue_key ) = @_;
#
#    my $issue = $self->http_get( $self->{_jira_url} . "issue/$issue_key"  );
#
#    return $issue;
#}
#
#sub get_project {
#    my ( $self, $project_key ) = @_;
#
#    my $issue = $self->http_get( $self->{_jira_url} . "project/$project_key"  );
#
#    return $issue;
#}
#
#sub create_issue {
#    my ( $self, $issue ) = @_;
#
#    my $resp = $self->http_post( $self->{_jira_url} . "issue/", $issue  );
#
#   #print Dumper( $issue ); 
#
#    print "\n\n => $resp\n"; 
#
#    return;
#}
#
#sub create_issues {
#    my ( $self, $issues ) = @_;
#
#    my $resp = $self->http_post( $self->{_jira_url} . "issue/bulk", $issues  );
#
#   #print Dumper( $issue );
#
#    print "\n\n => $resp\n";
#
#    return;
#}
#
#sub get_favorite_filters {
#    my ( $self ) = @_;
#
#    if ( $self->{_favorite_filters} ) { return $self->{_favorite_filters}; }
#
#    my $filters = $self->http_get( $self->{_jira_url} . "filter/favourite"  );
#
#    $self->{_favorite_filters} = $filters;
#
#    return $filters;
#}
#
#sub get_filter_by_name {
#    my ( $self, $name ) = @_;
#
#    my $filters = $self->get_favorite_filters();
#
#    my $filter_id = 0;
#
#    foreach my $filter ( @{ $filters } ) {
#
#        if ( $filter->{name} eq $name ) { $filter_id = $filter->{id} }
#    }
#
#    unless ( $filter_id ) { die "\nERROR: no filter id found for '$name'. It probably doesn't exist\n\n"; }
#
#    return $filter_id;
#}
#
#sub get_transition_data {
#    my ($self, $issue) = @_;
#
#    my $resp = $self->http_get( $self->{_jira_url} . "issue/$$issue{id}?expand=changelog"  );
#
#    print Dumper($resp); die;
#
#    return $$resp{transitions};
#}
#
#sub get_issues_from_jql {
#    my ( $self, $JQL ) = @_;
#
#    my %data = ( jql => $JQL, fields=>["summary"] );
#    my $resp = $self->http_post( $self->{_jira_url} . "search/", \%data  );
#
#    my $number_issues_found = $resp->{total} || 0;
#    unless ( $number_issues_found > 0 ) { return {}; }
#
#    return $resp->{issues};
#}
#
#sub get_issue_count_for_filter {
#    my ( $self, $filter_id ) = @_;
#
#    my $issue_count = 0;
#
#    my $search_url = $self->get_searchurl_for_filter($filter_id);
#
#    $search_url .= '&maxResults=0';
#
#    my $filter_count = $self->http_get( $search_url  );
#
#    $issue_count = $filter_count->{total};
#
#    return $issue_count;
#}
#
#sub get_issues_from_filter_with_limit {
#    my ( $self, $filter_id, $start_row, $row_limit, $custom_fields ) = @_;
#
#    my $search_url = $self->get_searchurl_for_filter($filter_id);
#
#    $search_url .= "&fields=" . join( ',', @{ $custom_fields } ) . "&startAt=$start_row&maxResults=$row_limit";
#
#    my $issues = $self->http_get( $search_url );
#
#    return $issues;
#}
#
#sub get_custom_fields {
#    my ( $self ) = @_;
#
#    if ( $self->{_custom_fields} ) { return; } 
#
#    my $fields = $self->http_get( $self->{_jira_url} . "field" );
#
#    my %custom_fields = ();
#
#    foreach my $field ( @{ $fields } ) {
#
#        unless ( $field->{custom} ) { next; }
#
#        my $name = $field->{name};
#        $name = $self->_change_field_name($name);
#
#        $custom_fields{$name} = $field->{id};
#    }
#
#    $self->{_custom_fields} = \%custom_fields;
#}
#
#sub get_searchurl_for_filter {
#    my ( $self, $filter_id ) = @_;
#
#    if ( $self->{_searchurls}{$filter_id} ) { return $self->{_searchurls}{$filter_id}; }
#
#    my $filter = $self->http_get( $self->{_jira_url} . "filter/$filter_id"  );
#
#    $self->{_searchurls}{$filter_id} = $filter->{searchUrl};
#
#    return $filter->{searchUrl};
#}
#
#sub get_comments_for_issue {
#    my ( $self, $issue_key ) = @_;
#
#    my $comments = $self->http_get( $self->{_jira_url} . "issue/$issue_key?fields=comment"  );
#
#    #print Dumper( $comments );
#
#    return;
#}
#
#sub transition_and_update_issue {
#    my ( $self, $issue_key, $action, $fields, $comment ) = @_;
#
#    print "UPDATE: $issue_key, $action, $fields, $comment\n";
#
#    my %data = ();
#
#    unless ( $self->{_transitions}{$action} ) { die "\nERROR: no trasition id for '$action'\n\n"; }
#
#    $data{transition}{id} = $self->{_transitions}{$action};
#
#    if ( $comment ) {
#        push( @{ $data{update}{comment} }, { 'add' => { body => $comment } } );
#    }
#
##    # can only update fields on the transition screen 
##    foreach my $field_name ( keys %{ $fields } ) {
##
##        my $field = $self->_change_field_name($field_name);
##
##        # is this a custom field
##        if ( $self->{_custom_fields}{$field} ) { $field = $self->{_custom_fields}{$field}; }
##
###
###        # TODO: this will break with real field names
###        unless ( $self->{_custom_fields}{$field} ) { die "\nERROR: unexpected custom field '$field_name'\n\n"; }
###
###        print "$field_name | $field |\n";
###
##        $data{fields}{$field}{name} = $fields->{$field_name};
##    }
#
#
#    my $resp = $self->http_post( $self->{_jira_url} . "issue/$issue_key/transitions", \%data  );
#
#   #print Dumper( $issue );
#
#    #print Dumper ( \%data );
#
#    print "\n\n => $resp\n";
#
#
#    return;
#}
#
#sub update_issue {
#    my ( $self, $issue_key, $fields, $comment ) = @_;
#
#    #print "UPDATE: $issue_key, $fields, $comment\n";
#
#    my %data = ();
#
#    if ( $comment ) {
#        push( @{ $data{update}{comment} }, { 'add' => { body => $comment } } );
#    }
#
#
#    foreach my $field_name ( keys %{ $fields } ) {
#
#        my $field = $self->_change_field_name($field_name);
#
#        if ( $self->{_custom_fields}{$field} ) { 
#
#
#            if (  $field eq 'questiontype' ) { 
#
#                $field = $self->{_custom_fields}{$field}; 
#    
#                $data{fields}{$field} = $fields->{$field_name};
#    
#                unless ( ref( $data{fields}{$field} ) eq 'HASH' ) {
#                    #die "\nWARNING: '$field' needs to be an object\n\n";
#                    # assume typo and try to fix
#                    delete( $data{fields}{$field} );
#                    $data{fields}{$field}{value} = $fields->{$field_name};
#                }
#            }
#            else {
#                $field = $self->{_custom_fields}{$field}; 
#                $data{fields}{$field} = $fields->{$field_name};
#            }
#        }
#        elsif ( $field eq 'assignee' ) {
#
#            $data{fields}{$field} = $fields->{$field_name};
#
#            unless ( ref( $data{fields}{$field} ) eq 'HASH' ) {
#                #die "\nWARNING: '$field' needs to be an object\n\n";
#                # assume typo and try to fix
#                delete( $data{fields}{$field} );
#                $data{fields}{$field}{name} = $fields->{$field_name};
#            }
#        }
#        elsif ( $field eq 'summary' ) {
#            $data{fields}{$field} = $fields->{$field_name};
#        }
#        elsif ( $field eq 'duedate' ) {
#            $data{fields}{$field} = $fields->{$field_name};
#        }
#        else {
#            $data{fields}{$field}{name} = $fields->{$field_name};
#        }
#    }
#
#    my $resp = $self->http_put( $self->{_jira_url} . "issue/$issue_key", \%data  );
#
#    print "\n\n => $resp\n"; 
#
#    return;
#}
#
##/rest/api/2/project
#sub get_projects {
#    my ( $self ) = @_;
#
#    my $resp = $self->http_get( $self->{_jira_url} . "project" );
#
#    #print "\n\n => $resp\n";
#
#    return $resp;
#}
#
#####################################################################################################
#
#sub getIssueCountForFilter {
#    my ( $self, $project ) = @_;
#
#    #$self->get_favorite_filters();
#    my $filter_id = $self->get_filter_by_name($project);
#
#    #print "ID: $filter_id\n";
#
#    my $issue_count = $self->get_issue_count_for_filter($filter_id);
#
#    #print "COUNT: $issue_count\n";
#
#    return $issue_count;
#}
#
#sub getIssueCountForJQL {
#    my ( $self, $jql ) = @_;
#
#    my $issue_count = 0;
#
##    my $search_url = $self->get_searchurl_for_filter($filter_id);
##
##    $search_url .= '&maxResults=0';
##
##    my $filter_count = $self->http_get( $search_url  );
##
##    $issue_count = $filter_count->{total};
#
#    return $issue_count;
#}
#
#sub getIssuesFromFilterWithLimit { 
#    my ( $self, $project, $start_row, $row_limit, $custom_fields ) = @_;
#
#    # convert custom field names to ids
#    my %fields = ();
#
#    # always add fields
#    $fields{'summary'} = 1;
#    #$fields{'comment'} = 1;
#
#    foreach my $field ( @{ $custom_fields } ) {
#
#        $field = $self->_change_field_name($field);
#
#        if ( $field eq 'projecteditor' ) { $field = 'reporter'; }
#
#        # is custom?
#        if ( $self->{_custom_fields}{$field} ) {
#            $fields{ $self->{_custom_fields}{$field} } = $field;
#        }
#        else {
#            $fields{$field} = $field;
#        }
#    };
#
#    my @desired_fields = ( keys %fields );
#
#    my %cleaned_issues = ();
#
#    my $filter_id = $self->get_filter_by_name($project); 
#
#    my $issues = $self->get_issues_from_filter_with_limit( $filter_id, $start_row, $row_limit, \@desired_fields ) || [];
#
#    foreach my $issue ( @{ $issues->{issues} } ) {
#
#        $cleaned_issues{ $issue->{id} }{issuekey} = $issue->{key};
#        $cleaned_issues{ $issue->{id} }{code}     = $issue->{fields}{summary};
#
#        foreach my $field_name ( keys %{ $issue->{fields} } ) {
#
#            if ( $field_name =~ m/^customfield_/ ) {
#                my $common_field_name = $fields{$field_name}; 
#                $cleaned_issues{ $issue->{id} }{$common_field_name} = $issue->{fields}{$field_name};    
#            }
#            elsif ( $field_name eq 'reporter' ) {
#                # change reporter to project editor
#                $cleaned_issues{ $issue->{id} }{'projecteditor'} = $issue->{fields}{$field_name}{name};
#                $cleaned_issues{ $issue->{id} }{$field_name} = $issue->{fields}{$field_name};    
#            }
#            elsif ( $field_name eq 'status' ) {
#                $cleaned_issues{ $issue->{id} }{$field_name} = $issue->{fields}{$field_name}{name};
#            }
#            elsif ( $field_name eq 'issuetype' ) {
#                $cleaned_issues{ $issue->{id} }{$field_name} = $issue->{fields}{$field_name}{name};
#            }
#            else {
#                $cleaned_issues{ $issue->{id} }{$field_name} = $issue->{fields}{$field_name};    
#            }
#        }
#
#
#    }
#
#    return \%cleaned_issues;
#}
#
##sub getComments {
##    my ( $self, $issue_key ) = @_;
##   
##    # slowwww 
##    #$self->get_comments_for_issue($issue_key);
##
##    return;
##}
#
#sub getIssue {
#    my ( $self, $issue_key ) = @_;
#
#    return $self->get_issue($issue_key);
#}
#
#sub getIssueBySummary {
#    my ( $self, $editorial_projects, $summary, $fields ) = @_;
#
#    my $project_key;
#    my $textbook_code;
#
#    if ( $summary =~ m/^(\w+) / ) {
#        $textbook_code = $1;
#        $project_key = $editorial_projects->{ uc( $textbook_code ) }{project_id};
#    } 
#
#    unless ( $project_key ) { return; print "\nWARNING: '$textbook_code' project not found in JIRA\n\n"; return; }
#
#    my $JQL = "summary ~ '$summary' and PROJECT = $project_key\n";
#
#    my %data = ( jql => $JQL, fields => [ "summary" ], maxResults => 2 );
#
#    my $resp = $self->http_post( $self->{_jira_url} . "search/", \%data  );
#
#    my $number_issues_found = $resp->{total} || 0;
#
#    unless ( $number_issues_found == 1 ) { return; }
##
##          'fields' => {
##                        'summary' => 'PriviteraStats2 2.TB.051.'
##                      },
##          'expand' => 'editmeta,renderedFields,transitions,changelog,operations',
##          'self' => 'https://jira.office.webassign.net/rest/api/2/issue/32805',
##          'id' => '32805',
##          'key' => 'CSMAAA-315'
##
#
#    my %cleaned_issue = ( issuekey => $resp->{issues}[0]{key} );
#
#    return \%cleaned_issue;
#}
#
#
#
#sub check_actions {
#    my ( $self, $issue_key, $next_steps ) = @_;
#
#    my $found    = '';
#    my @searches = ();
#
#    if ( ref( $next_steps ) eq 'ARRAY' ) {
#        @searches = @{ $next_steps };
#    }
#    else {
#        push( @searches, $next_steps );
#    }
#
#    # Get all available actions for this issue
#    my $actions = $self->http_get( $self->{_jira_url} . "issue/$issue_key/transitions"  );
#
#    my %availableActions = ();
#
#    foreach my $transition ( @{ $actions->{transitions} } ) {
#        $availableActions{ $transition->{name} } = 1;
#        $self->{_transitions}{ $transition->{name} } = $transition->{id};
#    }
#
#    my @action_names = keys( %availableActions );
#
#    my @matches = ();
#
#    foreach my $search_text ( @searches ) {
#        if ( @matches = grep( m/$search_text/i, @action_names ) ) {
#            last;
#        }
#    }
#
#    if ( scalar( @matches ) > 0 ) {
#        $found = $matches[0];
#    }
#
#    return $found;
#}
#
#
#####################################################################################################
#
#sub http_get {
#    my ( $self, $url, $params ) = @_;
#
#    print $url,"\n";
#    my $perl_scalar = {};
#
#    my $response = $self->{_uaref}->get( $url );
#
#    if ( $response->is_success ) {
#        $perl_scalar = $self->{_jsonref}->decode( $response->decoded_content );
#    }
#    else {
#        $perl_scalar->{status} =  $response->status_line;
#        
#    } 
#
#    return $perl_scalar;
#}
#
#sub http_post {
#    my ( $self, $url, $data ) = @_;
#
#    print $url,"\n";
#
#    my $json = $self->{_jsonref}->encode( $data );
#
#    #print $json;
#
#    my $response = $self->{_uaref}->post(
#        $url,
#        'Content-type'   => 'application/json;charset=utf-8',
#         Content          => encode_utf8( $json ),
#    );
#
##    my $resp;
##
##    if ( $response->is_success ) {
##        $resp =  $response->decoded_content;
##    }
##    else {
##        $resp = $response->status_line;
##
##        print $response->decoded_content; 
##    }
#
#    my $perl_scalar = {};
#
#    if ( $response->is_success ) {
#
#        if ( length( $response->decoded_content ) > 0 ) {
#
#            print "DUDE: =>".$response->decoded_content."<=\n";
#            $perl_scalar = $self->{_jsonref}->decode( $response->decoded_content );
#        }
#    }
#    else {
#        $perl_scalar->{status} =  $response->status_line;
#
#    }
#
#    return $perl_scalar;
#}
#
#sub http_put {
#    my ( $self, $url, $data ) = @_;
#
#    print $url,"\n";
#
#    my $json = $self->{_jsonref}->encode( $data );
#
#    print $json;
#
#    my $response = $self->{_uaref}->put(
#        $url,
#        'Content-type'   => 'application/json;charset=utf-8',
#         Content          => encode_utf8( $json ),
#    );
#
#    my $resp;
#
#    if ( $response->is_success ) {
#        $resp =  $response->decoded_content;
#    }
#    else {
#        $resp = $response->status_line;
#
#        print $response->decoded_content;
#    }
#
#    return $resp;
#}
#
#sub attach_file_to_issue {
#    my ( $self, $key, $filename ) = @_;
# 
#    my $url = $self->{_jira_url} . "issue/$key/attachments";
#
#    print $url,"\n";
#
#    my $response = $self->{_uaref}->post(
#        $url,
#        'Content-type'      => 'form-data',
#        'X-Atlassian-Token' => 'nocheck',             # required by JIRA XSRF protection
#        Content             => [ file => [ $filename ] ]
#    );
#
#    my $resp;
#
#    if ( $response->is_success ) {
#        $resp =  $response->decoded_content;
#    }
#    else {
#        $resp = $response->status_line;
#
#        print $response->decoded_content;
#    }
#
#    return $resp;
# 
#}
#
#############################################################################################################################
## Private
#
#sub _change_field_name {
#    my ( $self, $name ) = @_;
#    my $output = $name;
#    $output =~ s#[\s\(\)\:\.\-\/]##g;
#    $output = lc($output);
#    return $output;
#}
#
#1;
#

    action _merge_default_headers($headers) {
#     def merge_default_headers(headers)
#        {'Accept' => 'application/json'}.merge(headers)
#      end
        return;
    }

#}
#1;

__PACKAGE__->meta->make_immutable();
