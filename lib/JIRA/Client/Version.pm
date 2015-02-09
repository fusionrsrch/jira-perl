use MooseX::Declare;

class JIRA::Client::Version {

    use Data::Dumper;

    use Method::Signatures::Simple name => 'action';

    has 'MAJOR' => ( isa => 'Int', is => 'ro', default => 0 );
    has 'MINOR' => ( isa => 'Int', is => 'ro', default => 1 );
    has 'TINY'  => ( isa => 'Int', is => 'ro', default => 3 );
    has 'PATCH' => ( isa => 'Int', is => 'ro' );

    has 'STRING' => ( isa => 'Str', lazy => 1, is => 'ro', builder => '_build_STRING' );

    action _build_STRING() {
        my @array = ( $self->MAJOR, $self->MINOR, $self->TINY );
        push( @array, $self->PATCH ) if ( $self->PATCH );
        return join( '.', @array );
    }
}
