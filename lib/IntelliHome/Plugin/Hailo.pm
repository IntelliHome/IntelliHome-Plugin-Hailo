package IntelliHome::Plugin::Hailo;

=encoding utf-8

=head1 NAME

IntelliHome::Plugin::Hailo - Hailo plugin for Google@Home

=head1 SYNOPSIS

  $ ./intellihome-master -i Hailo #for install
  $ ./intellihome-master -r Hailo #for remove

=head1 DESCRIPTION

IntelliHome::Plugin::Hailo is a Hailo plugin that enables learning everything and answer back

=head1 METHODS

=over

=item speaktome

Takes input terms learn it and reply using Hailo
This plugin is just for fun, not going to core anyway :P

=item install
Install the plugin into the mongo Database

=item remove
Remove the plugin triggers from the mongo Database

=back

=head1 AUTHOR

mudler E<lt>mudler@dark-lab.netE<gt>

=head1 COPYRIGHT

Copyright 2014- mudler

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO
L<Hailo>
=cut

use strict;
use 5.008_005;
our $VERSION = '0.02';
use Moose;
use Hailo;
extends 'IntelliHome::Plugin::Base';
has 'brain' => ( is => "rw", default => 'googleathome.db' );
has 'Hailo' => ( is => "rw" );

sub BUILD {
    my $self = shift;
    $self->Hailo( Hailo->new( brain => $self->brain ) );

}

sub speaktome {
    my $self   = shift;
    my $Said   = shift;
    my $Phrase = join( " ", @{ $Said->result } );
    $self->Hailo->learn($Phrase);
    $self->IntelliHome->Output->info( $self->Hailo->reply($Phrase) );
    return $Phrase;
}

sub install {
    my $self = shift;
    $self->IntelliHome->Backend->installPlugin(
        {   regex         => '(.*)',
            command       => '',
            plugin        => "Hailo",
            plugin_method => "speaktome"
        }
    );

}

sub remove {
    my $self = shift;
    $self->IntelliHome->Backend->removePlugin( { plugin => "Hailo", } );
}

1;
__END__
