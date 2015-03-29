#use MooseX::Declare;

#class JIRA::Client::Base {
package JIRA::Client::Base;

    use Mouse;

    use Data::Dumper;

    use JSON;
    use URI::Encode;

    use Method::Signatures::Simple name => 'action';

    has 'client'        => ( isa => 'JIRA::Client', is => 'rw' );
#    has 'key_attribute' => ( isa => 'Str', is => 'rw', default => 'id' ); 
    has 'url'           => ( is => 'rw' );
    has 'attrs'         => ( isa => 'HashRef', is => 'rw' );

    # Finds and retrieves a resource with the given ID.
    action find($key, $options) {
        my $instance = $self->new( client => $self->client, options => $options);
        my $attrs = $self->attrs();
        $attrs->{ $self->key_attribute } = $key;
        $instance->attrs( $attrs );
        $instance->fetch( 0, $self->query_params_for_single_fetch($options) );
        return $instance;
    }
#    def self.find(client, key, options = {})
#      instance = self.new(client, options)
#      instance.attrs[key_attribute.to_s] = key
#      instance.fetch(false, query_params_for_single_fetch(options))
#      instance
#    end

    # Builds a new instance of the resource with the given attributes.
    # These attributes will be posted to the JIRA Api if save is called.
    action build($attrs) {
        my %attributes = ();
        $attributes{id} = $attrs->{id};
        foreach my $key ( keys %{ $attrs->{fields} } ) { 
            $attributes{$key} = $attrs->{fields}{$key};
        }
        #print Dumper( \%attributes );
        return $self->new(\%attributes);
    }
#    def self.build(client, attrs)
#      self.new(client, :attrs => attrs)
#    end

    action query_params_for_single_fetch($options) {
        # umm
    }
#  def self.query_params_for_single_fetch(options)
#      Hash[options.select do |k,v|
#        QUERY_PARAMS_FOR_SINGLE_FETCH.include? k
#      end]
#    end
#
    #
    #

    # Fetches the attributes for the specified resource from JIRA unless
    # the resource is already expanded and the optional force reload flag
    # is not set
    action fetch($reload, $query_params) {
        my $response = $self->client->get( $self->url_with_query_params( $self->url, $query_params) );
    }
#    def fetch(reload = false, query_params = {})
#      return if expanded? && !reload
#      response = client.get(url_with_query_params(url, query_params))
#      set_attrs_from_response(response)
#      @expanded = true
#    end
#

    action url_with_query_params($url, $query_params) {
        if ( $query_params ) {
            my $params = $self->hash_to_query_string($query_params);
            return "$url?$params";
        }
        else {
            return $url; 
        }            
    }
#    def url_with_query_params(url, query_params)
#      if not query_params.empty?
#        "#{url}?#{hash_to_query_string query_params}"
#      else
#        url
#      end
#    end

    action hash_to_query_string($query_params) {
        my $string = '';   
        my $uri = URI::Encode->new( { encode_reserved => 0 } );
        foreach my $key ( keys %{ $query_params } ) {
            $string .= $uri->encode( $key ) . "=" . $uri->encode( $query_params->{$key} ) . '&';
        }
        chop($string);
        return $string;
    }
#def hash_to_query_string(query_params)
#      query_params.map do |k,v|
#        CGI.escape(k.to_s) + "=" + CGI.escape(v.to_s)
#      end.join('&')
#    end
#
#}
    action key_attribute() {
        return 'id';
    }

    action has_one($resource, $options) {
        #print Dumper( $options );
        my $class = $options->{class} || 'Str' ;
        print "KLASS $class\n";
        has $resource => ( isa => $class, is => 'rw', default => 'dude' );
        return; 
    }

#  def self.has_one(resource, options = {})
#      attribute_key = options[:attribute_key] || resource.to_s
#      child_class = options[:class] || ('JIRA::Resource::' + resource.to_s.classify).constantize
#      define_method(resource) do
#        attribute = maybe_nested_attribute(attribute_key, options[:nested_under])
#        return nil unless attribute
#        child_class.new(client, :attrs => attribute)
#      end
#    end
#

    action parse_json($string) {
        my $json = JSON->new();
        return $json->decode($string);
#        return;
    }
#def self.parse_json(string) # :nodoc:
#      JSON.parse(string)
#    end


__PACKAGE__->meta->make_immutable();
