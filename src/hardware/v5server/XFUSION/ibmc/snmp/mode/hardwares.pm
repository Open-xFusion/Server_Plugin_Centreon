package hardware::v5server::XFUSION::ibmc::snmp::mode::hardwares;

use base qw(centreon::plugins::mode);

use strict;
use warnings;
use hardware::v5server::XFUSION::ibmc::snmp::mode::components::system;
use hardware::v5server::XFUSION::ibmc::snmp::mode::components::cpu;
use hardware::v5server::XFUSION::ibmc::snmp::mode::components::fan;
use hardware::v5server::XFUSION::ibmc::snmp::mode::components::raid;
use hardware::v5server::XFUSION::ibmc::snmp::mode::components::memory;
use hardware::v5server::XFUSION::ibmc::snmp::mode::components::psu;
use hardware::v5server::XFUSION::ibmc::snmp::mode::components::disk;


sub new {
    my ($class, %options) = @_;
    my $self = $class->SUPER::new(package => __PACKAGE__, %options);
    bless $self, $class;
    
    $self->{version} = '1.0';
    $options{options}->add_options(arguments =>
                                {      
                                  "component:s"             => { name => 'component', default => 'system' }, 
                                });
    $self->{components} = {};
    $self->{no_components} = undef;
    return $self;
}

sub check_options {
    my ($self, %options) = @_;
    $self->SUPER::init(%options); 
}

sub run {
    my ($self, %options) = @_;
    $self->{snmp} = $options{snmp};
    
    if ($self->{option_results}->{component} eq 'system') {
        hardware::v5server::XFUSION::ibmc::snmp::mode::components::system::check($self);
    } elsif ($self->{option_results}->{component} eq 'cpu') {
        hardware::v5server::XFUSION::ibmc::snmp::mode::components::cpu::check($self);
    } elsif ($self->{option_results}->{component} eq 'fan') {
        hardware::v5server::XFUSION::ibmc::snmp::mode::components::fan::check($self);
    } elsif ($self->{option_results}->{component} eq 'raid') {
        hardware::v5server::XFUSION::ibmc::snmp::mode::components::raid::check($self);
    } elsif ($self->{option_results}->{component} eq 'memory') {
        hardware::v5server::XFUSION::ibmc::snmp::mode::components::memory::check($self);
    } elsif ($self->{option_results}->{component} eq 'psu') {
        hardware::v5server::XFUSION::ibmc::snmp::mode::components::psu::check($self);
    } elsif ($self->{option_results}->{component} eq 'disk') {
        hardware::v5server::XFUSION::ibmc::snmp::mode::components::disk::check($self);
    } else {
        $self->{output}->add_option_msg(short_msg => "Wrong option. Cannot find component '" . $self->{option_results}->{component} . "'.");
        $self->{output}->option_exit();
    }  
    
    $self->{output}->display();
    $self->{output}->exit();
}

1;

__END__