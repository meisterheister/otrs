# --
# Copyright (C) 2014-2017 Deny Dias, https://mexapi.macpress.com.br/about
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --


package Kernel::Language::de_SupportQuota;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    # Kernel/Config/Files/SupportQuota.xml
    $Lang->{'Shows the customer support quota widget in the ticket zoom view.'} = '';
    $Lang->{'Quota recurrence period.'} = '';
    $Lang->{'Monthly'} = 'Monatlich';
    $Lang->{'Yearly'} = 'Jährlich';
    $Lang->{'Disabled'} = '';
    $Lang->{'Display Customer Support Quota widget even if no quota is set to a customer.'} = '';
    $Lang->{'No'} = 'Nein';
    $Lang->{'Yes'} = 'Ja';
    $Lang->{'Placement of Support Quota widget in TicketZoom sidebar.'} = '';
    $Lang->{'Top'} = '';
    $Lang->{'Bottom'} = '';

    # Kernel/Output/HTML/Templates/Standard/SupportQuotaAgent.tt
    $Lang->{'Customer Support Quota'} = 'Quota Kundensupport';
    $Lang->{'Available'} = 'Verfügbar';
    $Lang->{'Used'} = 'Verbraucht';
    $Lang->{'Contracted'} = 'Vertrag';

    # Kernel/Output/HTML/OutputFilter/SupportQuota.pm
    $Lang->{'(Monthly)'} = '(Monatlich)';
    $Lang->{'(Yearly)'} = '(Jährlich)';

    # Kernel/config.pm (added manually after installation)
    $Lang->{'Quota'} = '';
}

1;
