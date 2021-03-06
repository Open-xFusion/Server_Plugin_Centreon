package hardware::v5server::XFUSION::ibmc::snmp::mode::components::disk;

use strict;
use warnings;

sub check {
    my ($self) = @_;
    
    my %statusHash = ("1"=>"ok","2"=>"warning","3"=>"warning","4"=>"critical","5"=>"unknown","6"=>"unknown");
    my %eachStatus = ("1"=>"ok","2"=>"minor","3"=>"major","4"=>"critical","5"=>"absence","6"=>"unknown");     
     
    my $diskStatusOid = ".1.3.6.1.4.1.2011.2.235.1.1.18.1.0";        
    my $presentTableOid = ".1.3.6.1.4.1.2011.2.235.1.1.18.50.1.2";
    my $statusTableOid = ".1.3.6.1.4.1.2011.2.235.1.1.18.50.1.3";
    my $deviceTableOid = ".1.3.6.1.4.1.2011.2.235.1.1.18.50.1.6";
    
    my $tmpShortMessage = "";
    my $totalPresent = 0;
    my $totalComponent = 0;
    my $result = $self->{snmp}->get_table(oid => $presentTableOid);
    if (scalar(keys %$result) <= 0)
    {
        $tmpShortMessage = $tmpShortMessage."No Disk presence.";
    }else 
    {   
        my $endKey;
        my $temnameOid;
        my $statusOid;
        my $tmpMsg;
        my $tmpresult;
        my $v;
        foreach my $k ($self->{snmp}->oid_lex_sort(keys %$result))
        {
            $v = $result->{$k};
            $endKey = "0";
            $temnameOid = "";
            $statusOid = "";
            $tmpMsg = "";
            $totalComponent++;
            if ($v eq "2")  # disk present  
            {   
                $totalPresent++;
                $k =~ /\.([0-9]+)$/;
                $endKey = $1;
                $temnameOid = $deviceTableOid.".".$endKey;
                $statusOid = $statusTableOid.".".$endKey;
                $tmpresult = $self->{snmp}->get_leef(oids =>[$temnameOid]);
                $tmpMsg = $tmpresult->{$temnameOid}.":";
                $tmpresult = $self->{snmp}->get_leef(oids =>[$statusOid]);
                $tmpMsg = $tmpMsg.$eachStatus{$tmpresult->{$statusOid}}." ";
                $tmpShortMessage = $tmpShortMessage.$tmpMsg;
            }
        }       
    } 
    $result = $self->{snmp}->get_leef(oids =>[$diskStatusOid]);
    $tmpShortMessage = "diskPresence:".$totalPresent."\/".$totalComponent." ".$tmpShortMessage;

    $self->{output}->output_add(severity => $statusHash{$result-> {$diskStatusOid}},
                                short_msg => $tmpShortMessage );

    $self->{output}->display(); 
    $self->{output}->exit();
}
1;