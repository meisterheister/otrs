# --
# Copyright (C) 2014-2016 Deny Dias, https://mexapi.macpress.com.br/foss
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --


package Kernel::Language::pt_BR_SupportQuota;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    # Kernel/Config/Files/SupportQuota.xml
    $Lang->{'Shows the customer support quota widget in the ticket zoom view.'} = '';
    $Lang->{'Quota recurrence period.'} = '';
    $Lang->{'Monthly'} = 'Mensal';
    $Lang->{'Yearly'} = 'Anual';
    $Lang->{'Disabled'} = '';
    $Lang->{'Display Customer Support Quota widget even if no quota is set to a customer.'} = '';
    $Lang->{'No'} = '';
    $Lang->{'Yes'} = '';
    $Lang->{'Placement of Support Quota widget in TicketZoom sidebar.'} = '';
    $Lang->{'Top'} = '';
    $Lang->{'Bottom'} = '';

    # Kernel/Output/HTML/Templates/Standard/SupportQuotaAgent.tt
    $Lang->{'Customer Support Quota'} = 'Cota de Suporte do Cliente';
    $Lang->{'Available'} = 'Disponível';
    $Lang->{'Used'}  = 'Utilizado';
    $Lang->{'Contracted'} = 'Contratado';

    # Kernel/Output/HTML/OutputFilter/SupportQuota.pm
    $Lang->{'(Monthly)'} = '(Mensal)';
    $Lang->{'(Yearly)'} = '(Anual)';

    # Kernel/config.pm (added manually after installation)
    $Lang->{'Quota'} = '';
}

1;
