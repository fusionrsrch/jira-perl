use MooseX::Declare;

class JIRA::Client::Base {

    use Data::Dumper;

    use Method::Signatures::Simple name => 'action';

    has 'client' => ( isa => 'JIRA::Client', is => 'rw' );
    has 'url' => ( is => 'rw' );

    action find($key, $options) {
        my $instance = $self->new( client => $self->client, options => $options);
        $instance->fetch( 0, query_params_for_single_fetch($options) );
        return $instance;
    }
#    action   def self.find(client, key, options = {})
#      instance = self.new(client, options)
#      instance.attrs[key_attribute.to_s] = key
#      instance.fetch(false, query_params_for_single_fetch(options))
#      instance
#    end
#
#    :

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
        my $response = $self->client->get( url_with_query_params( $self->url, $query_params) );
    }
#    def fetch(reload = false, query_params = {})
#      return if expanded? && !reload
#      response = client.get(url_with_query_params(url, query_params))
#      set_attrs_from_response(response)
#      @expanded = true
#    end
#

    action url_with_query_params($url, $query_params) {
    }
#    def url_with_query_params(url, query_params)
#      if not query_params.empty?
#        "#{url}?#{hash_to_query_string query_params}"
#      else
#        url
#      end
#    end

}
