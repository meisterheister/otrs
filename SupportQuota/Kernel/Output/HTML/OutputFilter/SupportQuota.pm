# --
# Copyright (C) 2014-2016 Deny Dias, https://mexapi.macpress.com.br/foss
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::OutputFilter::SupportQuota;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Web::Request'
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # load required objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $DBObject     = $Kernel::OM->Get('Kernel::System::DB');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get template name
    my $Templatename = $Param{TemplateFile} || '';

    # return if template is empty
    return 1 if !$Templatename;

    # return if not in AgentTicketZoom
    return 1 if $Templatename ne 'AgentTicketZoom';

    # get the TicketID
    $Self->{TicketID} = $ParamObject->GetParam( Param => 'TicketID' );

    # return if TicketID is empty
    return if !$Self->{TicketID};

    # get data
    my %Data = ();

    # auxiliary sql statement for the recurrence period
    my $Recurrence      = $ConfigObject->Get('SupportQuota::Preferences::Recurrence');
    my $RecurrenceLabel = "";
    my $SqlRecurrence   = "";
    if ( $Recurrence eq 'month' ) {
        $RecurrenceLabel = "(Monthly)";
        $SqlRecurrence   = "
                AND EXTRACT(YEAR FROM ta.create_time) = EXTRACT(YEAR FROM NOW())
                AND EXTRACT(MONTH FROM ta.create_time) = EXTRACT(MONTH FROM NOW())";
    }
    elsif ( $Recurrence eq 'year' ) {
        $RecurrenceLabel = "(Yearly)";
        $SqlRecurrence   = "
                AND EXTRACT(YEAR FROM ta.create_time) = EXTRACT(YEAR FROM NOW())";
    }
    else {
        $RecurrenceLabel = "";
    }

    # main sql statement with mandatory data
    my $SQL = "
        SELECT  cc.cquota AS Cquota,
                SUM(COALESCE(ta.time_unit, 0)) AS Uquota
        FROM    customer_company cc
        LEFT OUTER JOIN ticket t
                ON t.customer_id = cc.customer_id
        LEFT OUTER JOIN time_accounting ta
                ON ta.ticket_id = t.id
                ${SqlRecurrence}
        WHERE   cc.customer_id = (SELECT customer_id FROM ticket WHERE id = ?)
        GROUP   BY cc.customer_id";

    # return if result set is empty
    return if !$DBObject->Prepare(
        SQL   => $SQL,
        Bind  => [ \$Self->{TicketID} ],
        Limit => 1,
    );

    # process result set
    while ( my @Row = $DBObject->FetchrowArray() ) {

        # initialize undefined data sources
        if ( defined $Row[0] ) {
            $Data{ContractQuota} = $Row[0];
        }
        else {
            $Data{ContractQuota} = 0;
        }
        if ( defined $Row[1] ) {
            $Data{UsedQuota} = $Row[1];
        }
        else {
            $Data{UsedQuota} = 0;
        }
    }

    # format and calculate remaining information
    my $ContractQuota  = sprintf '%.1f', $Data{ContractQuota};
    my $UsedQuota      = sprintf '%.1f', $Data{UsedQuota};
    my $AvailableQuota = sprintf '%.1f', $Data{ContractQuota} - $Data{UsedQuota};

    # return if config does not allow widget display if empty customer quota
    if (
        $ContractQuota == 0
        && $ConfigObject->Get('SupportQuota::Preferences::EmptyContractDisplay') == 0
        )
    {
        return;
    }

    # information for AgentTicketZoom
    if ( $Templatename eq 'AgentTicketZoom' ) {

        # set template and information values
        my $Snippet = $LayoutObject->Output(
            TemplateFile => 'SupportQuotaAgent',
            Data         => {
                Available  => $AvailableQuota,
                Used       => $UsedQuota,
                Contracted => $ContractQuota,
                Recurrence => $RecurrenceLabel
                }
        );

        # get the position for the output, default to bottom
        my $Position = $ConfigObject->Get('SupportQuota::Preferences::Position') || 'bottom';

        # add information according to the requested position
        if ( $Position eq 'top' ) {
            ${ $Param{Data} } =~ s{(<div \s+ class="SidebarColumn">)}{$1 $Snippet}xsm;
        }
        else {
            ${ $Param{Data} } =~ s{(</div> \s+ <div \s+ class="ContentColumn)}{ $Snippet $1 }xms;
        }
    }

    # done, return information
    return ${ $Param{Data} };

}

1;
