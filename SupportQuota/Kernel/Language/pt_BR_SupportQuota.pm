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
    $Lang->{'Shows the customer support quota widget in the ticket zoom view.'} = 'Mostra ao agente o widget Cota de Suporte do Cliente nos detalhes do chamado.';
    $Lang->{'Quota recurrence period.'} = 'Período de recorrência da cota.';
    $Lang->{'Monthly'} = 'Mensal';
    $Lang->{'Yearly'} = 'Anual';
    $Lang->{'Disabled'} = 'Sem recorrência';
    $Lang->{'Display Customer Support Quota widget even if no quota is set to a customer.'} = 'Mostrar o widget Cota de Suporte do Cliente mesmo se não houver uma cota estipulada ao cliente.';
    $Lang->{'No'} = 'Não';
    $Lang->{'Yes'} = 'Sim';
    $Lang->{'Placement of Support Quota widget in TicketZoom sidebar.'} = 'Posição do widget na barra lateral dos detalhes do chamado.';
    $Lang->{'Top'} = 'Em cima';
    $Lang->{'Bottom'} = 'Embaixo';

    # Kernel/Output/HTML/Templates/Standard/SupportQuotaAgent.tt
    $Lang->{'Customer Support Quota'} = 'Cota de Suporte do Cliente';
    $Lang->{'Available'} = 'Disponível';
    $Lang->{'Used'}  = 'Utilizado';
    $Lang->{'Contracted'} = 'Contratado';

    # Kernel/Output/HTML/OutputFilter/SupportQuota.pm
    $Lang->{'(Monthly)'} = '(Mensal)';
    $Lang->{'(Yearly)'} = '(Anual)';

    # Kernel/config.pm (added manually after installation)
    $Lang->{'Quota'} = 'Cota';
}

1;
