# --
# Hungarian translation for SupportQuota.
# Copyright (C) 2014-2016 Deny Dias, https://mexapi.macpress.com.br/foss
# Copyright (C) 2016 Balázs Úr, http://www.otrs-megoldasok.hu
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --


package Kernel::Language::hu_SupportQuota;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    my $Lang = $Self->{Translation};

    # Kernel/Config/Files/SupportQuota.xml
    $Lang->{'Shows the customer support quota widget in the ticket zoom view.'} =
        'Megjeleníti az ügyfél támogatási kvóta felületi elemet a jegynagyítás nézetben.';
    $Lang->{'Quota recurrence period.'} = 'A kvóta ismétlődési időszaka.';
    $Lang->{'Monthly'} = 'Havonta';
    $Lang->{'Yearly'} = 'Évente';
    $Lang->{'Disabled'} = 'Letiltva';
    $Lang->{'Display Customer Support Quota widget even if no quota is set to a customer.'} =
        'Az ügyfél támogatási kvóta felületi elem megjelenítése akkor is, ha nincs kvóta beállítva egy ügyfélhez.';
    $Lang->{'No'} = 'Nem';
    $Lang->{'Yes'} = 'Igen';
    $Lang->{'Placement of Support Quota widget in TicketZoom sidebar.'} =
        'A támogatási kvóta felületi elem elhelyezése a jegynagyítás oldalsávján.';
    $Lang->{'Top'} = 'Fent';
    $Lang->{'Bottom'} = 'Lent';

    # Kernel/Output/HTML/Templates/Standard/SupportQuotaAgent.tt
    $Lang->{'Customer Support Quota'} = 'Ügyfél támogatási kvóta';
    $Lang->{'Available'} = 'Elérhető';
    $Lang->{'Used'} = 'Elhasznált';
    $Lang->{'Contracted'} = 'Szerződött';

    # Kernel/Output/HTML/OutputFilter/SupportQuota.pm
    $Lang->{'(Monthly)'} = '(havonta)';
    $Lang->{'(Yearly)'} = '(évente)';

    # Kernel/config.pm (added manually after installation)
    $Lang->{'Quota'} = 'Kvóta';
}

1;
