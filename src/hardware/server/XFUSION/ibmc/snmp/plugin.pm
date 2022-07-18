
package hardware::server::XFUSION::ibmc::snmp::plugin;

use strict;
use warnings;
use base qw(centreon::plugins::script_snmp);

sub new {
    my ($class, %options) = @_;
    my $self = $class->SUPER::new(package => __PACKAGE__, %options);
    bless $self, $class;

    $self->{version} = '1.0';
    %{$self->{modes}} = (
                         'hardwares' => 'hardware::server::XFUSION::ibmc::snmp::mode::hardwares',
                         );

    return $self;
}
1;
__END__


=head1 PLUGIN DESCRIPTION

Check XFUSION servers  in SNMP.

=cut
