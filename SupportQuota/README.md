# OTRS Support Quota Add-on

This OTRS Add-on module provides an easy to use interface to control customer contracted work unit quotas.

By entering a quota to each Customer Company in your OTRS system and taking care to set the proper 'CustomerCompanyID' on your tickets (easy if you use PostMaster Filters), this add-on is able to get the total work unit quota available to a particular customer, how many work units were used in the current period and how many work units are available to that customer in the same period. Periods can be the current month or year. If the available quota is negative, there will be extra bucks in the end of the period.

The above information then appears in a widget under both AgentTicketZoom and overall Customer interfaces. That way agents can easily decide how to charge (or not) for beyond quota customers, while customers can keep track of their support quota usage.

## Screenshots

The screenshot bellow shows how the Support Quota works in the AgentTicketZoom:

![Support Quota Add-on in action: AgentTicketZoom](https://raw.githubusercontent.com/denydias/otrs/master/SupportQuota/SupportQuota_Agent.png)

The screenshot bellow shows how the Support Quota works in the Customer interface:

![Support Quota Add-on in action: customer.pl](https://raw.githubusercontent.com/denydias/otrs/master/SupportQuota/SupportQuota_Customer.png)

## OTRS Framework Version Requirements

- **Support Quota 0.x Series:** compatible with OTRS 3.3.x only.
- **Support Quota 1.x Series:** compatible with OTRS 4.x only.
- **Support Quota 2.x Series:** compatible with OTRS 5.x only.
- **Support Quota 3.x Series:** compatible with OTRS 6.x only.

## Instalation

Right in this repo, there is an [OTRS Package](https://github.com/denydias/otrs/tree/master/packages) named `SupportQuota-*.opm` ready to install. Download it, open your OTRS and go to Admin > Package Manager. Then choose the downloaded package in 'Install Package'.

The package installation takes care of the only database change required. For the matter of the record, it is:

```sql
ALTER TABLE customer_company ADD cquota SMALLINT;
```

After installation is done, you have to **manually** change your `Kernel/Config.pm` file as per the example bellow:

```perl
    # Custom CustomerCompany for Support Quota Add-on     #
    # --------------------------------------------------- #

    $Self->{CustomerCompany} = {
        Name   => 'Database Backend',
        Module => 'Kernel::System::CustomerCompany::DB',
        Params => {
            Table => 'customer_company',
            CaseSensitive => 0,
        },

        CustomerCompanyKey             => 'customer_id',
        CustomerCompanyValid           => 'valid_id',
        CustomerCompanyListFields      => [ 'customer_id', 'name' ],
        CustomerCompanySearchFields    => ['customer_id', 'name'],
        CustomerCompanySearchPrefix    => '',
        CustomerCompanySearchSuffix    => '*',
        CustomerCompanySearchListLimit => 250,
        CacheTTL                       => 60 * 60 * 24, # use 0 to turn off cache

        Map => [
            [ 'CustomerID',             'CustomerID', 'customer_id', 0, 1, 'var', '', 0 ],
            [ 'CustomerCompanyName',    'Customer',   'name',        1, 1, 'var', '', 0 ],
            [ 'CustomerCompanyStreet',  'Street',     'street',      1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyZIP',     'Zip',        'zip',         1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyCity',    'City',       'city',        1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyCountry', 'Country',    'country',     1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyURL',     'URL',        'url',         1, 0, 'var', '$Data{"CustomerCompanyURL"}', 0 ],
            [ 'CustomerCompanyComment', 'Comment',    'comments',    1, 0, 'var', '', 0 ],
            [ 'CustomerCompanyQuota',   'Quota',      'cquota',      1, 0, 'int', '', 0 ],
            [ 'ValidID',                'Valid',      'valid_id',    0, 1, 'int', '', 0 ],
        ],
    };
```

Note the new `CustomerCompanyQuota` field in the map.

Optionally, you might want to check `Admin > Sysconfig > SupportQuota > SupportQuota::Preferences` and set some desired behavior.

And that's it. Enjoy your extra $$$.

## Upgrading from Support Quota 1.x (OTRS4) to Support Quota 2.x (OTRS5)

Due do OTRS5 framework changes, if you already use [Support Quota 1.x series](https://github.com/denydias/otrs/releases) in OTRS4, you have to promote some changes in your OTRS backend before upgrade to Support Quota 2.x series.

1. [Upgrade OTRS 4 to OTRS 5](https://otrs.github.io/doc/manual/admin/stable/en/html/upgrading.html).

2. Run the following query in your OTRS database:

    ```sql
    ALTER TABLE `customer_company` CHANGE `quota` `cquota` SMALLINT( 6 ) NULL DEFAULT NULL ;
    ```

3. Change `Kernel/Config.pm` file so it reads:

    ```perl
    [ 'CustomerCompanyQuota',   'Quota',      'cquota',      1, 0, 'int', '', 0 ],
    ```

4. Upgrade to Support Quota 2.x.

## How To Use It

There are many use cases (aka support process) where this add-on could fit. I can't imagine it all. As such, I'll describe how one can use it under a use case I know better: myself.

1. Each one of your customers (**their companies, not their people**) should have an entry under Admin > Customer (`AdminCustomerCompany`).

2. For each customer company, set the quota for that customer. This is an integer from 0 to 65535 which corresponds to the customer contract (i.e. 8h, 16h, 24h, 720h). Leave it blank or 0 (zero) if you don't know or the customer has an unlimited service.

3. (OPTIONAL, but highly recommended) Set a Postmaster Filter for any of your customer companies like this:

    ```
    From: .*@customerdomain.com
    X-OTRS-CustomerNo: customername
    ```

    This ensures that any new ticket get the proper 'CustomerCompanyID' properly set when a new support email arrive.

    **Caveat:** If an agent open a ticket, the 'CustomerCompanyID' should be set manually. The same applies for phone tickets.

4. (OPTIONAL, but highly recommended) Go to Admin > SysConfig > Ticket > Frontend::Agent and set:

   ```
   Ticket::Frontend::TimeUnits: (work units)
   Ticket::Frontend::NeedAccountedTime: yes
   ```

   This ensures that every agent action upon a ticket needs to be time accounted.

5. Now that you are all set on OTRS side, every time an agent get into a new ticket to work on it, the time accounted to a particular customer is shown in the little panel at right. If the customer have no quota available, the agent can request a written authorization to charge the above quota service or just deny further developments.

### Usage Notes

The Support Quota widget in AgentTicketZoom shows the quota for the current period only and just for the particular 'CustomerCompanyID' set to the ticket. If you need to get a report by the end of a particular period to charge the extra work units, you must go to Admin > SQL Box and run a query like:

```sql
SELECT t.tn "Ticket #",
   t.title Title,
   t.customer_id Customer,
   SUM(ta.time_unit) "Work Units",
   DATE_FORMAT(t.create_time, "%h:%m:%s %d/%m/%Y") Created
FROM ticket t
   LEFT JOIN time_accounting ta ON ta.ticket_id=t.id
WHERE
   ta.time_unit IS NOT NULL
   AND t.customer_id="CustomerCompanyID"
   AND EXTRACT(YEAR FROM ta.create_time) = EXTRACT(YEAR FROM NOW())
   AND EXTRACT(MONTH FROM ta.create_time) = EXTRACT(MONTH FROM NOW())
GROUP BY t.tn
ORDER BY t.create_time
```

Don't forget to change `CustomerCompanyID` above to the one the matches your customer in OTRS. You may get a report for other periods by replacing `NOW()` inside `EXTRACT()` clauses with a full date, for instance: `2015-01-01`.

From within SQL Box you can save a CSV file so you can share the report.

## To Do

I'm not a Perl developer. I did the best I could to write this add-on with the core functionality in place. So, there are lots to improve in it for which pull requests are more than welcome.

As an start point, I'll give you the following items as a 'To Do List':

- [x] Properly implement the OTRS template mechanism. (done by [@reneeb](https://github.com/reneeb) in [6c35790b23](https://github.com/denydias/otrs/commit/6c35790b230104b2124fb2b8a61f63feba4b56bf))
- [x] Add localization support (Brazilian Portuguese is hardcoded). If you need the strings that need translation, open an issue and I'll be more than pleased to provide them. (done by [@reneeb](https://github.com/reneeb) in [6c35790b23](https://github.com/denydias/otrs/commit/6c35790b230104b2124fb2b8a61f63feba4b56bf))
- [ ] Add visual cues to over quota customers.
- [ ] Provide notification methods to automatically reply to customers working beyond the contracted quota upon new tickets.

This is just to name a few. I'm open to more.

### By Users

These are suggested by users:

#### reneeb

At http://forums.otterhub.org/viewtopic.php?f=64&t=25727&p=102624#p102527.

- [X] All the information can be gathered in one single SQL statement with some outer joins. (**Note:** I managed to get all data with one ANSI SQL statement (well, not exactly as there is a subquery). The new SQL should now be portable between DBMS supported by OTRS, but it was tested only in MySQL and MariaDB. I do not have access to PostgreSQL, Oracle or MSSQL to proceed with further tests. I appreciate if someone out there could validate the new SQL on these.)
- [X] Check if a TicketID is set (someone might use the output filter for an action that doesn't have a TicketID and that would lead to an error) and return if no ID is set.
- [X] `year()` and `month()` are not portable. (**Note:** Please see the SQL comment above.)

#### edicarloslds

- [X] Add the widget to AgentCustomerInformationCenter. The contribution (PR #13) is even more complete, providing an elegant widget overall Customer interface.

## References

To write this OTRS add-on, my first one, I counted on many references. Bellow I list the main ones:

1. [OTRS - Developer Manual](https://otrs.github.io/doc/manual/developer/stable/en/html/index.html)

2. From OtterHub e.V. User Forums:

    [How to add a field in the company details window](http://forums.otterhub.org/viewtopic.php?f=53&t=18627)

    [Problem with adding new fields to customer_company](http://forums.otterhub.org/viewtopic.php?f=62&t=25080)

    [Custom Field on "Add Customer" page](http://forums.otterhub.org/viewtopic.php?f=53&t=11508)

    [Add "next ticket" button in AgentTicketZoom](http://forums.otterhub.org/viewtopic.php?f=64&t=16586)

3. [Znuny Repo](https://github.com/znuny)

4. [OTRS Package that allows SMS sending](https://github.com/richieri/SmsEvent)

I'd like to acknowledge and thanks all the above list.

## License

Copyright (C) 2014-2017 Deny Dias, https://mexapi.macpress.com.br/about

With kind contributions by:

* [@reneeb](https://github.com/reneeb)
* [@lermit](https://github.com/lermit)
* [@maulkin](https://github.com/maulkin)
* [@urbalazs](https://github.com/urbalazs)
* [@edicarloslds](https://github.com/edicarloslds)
* [@meisterheister](https://github.com/meisterheister)

This software comes with ABSOLUTELY NO WARRANTY. For details, see the enclosed file COPYING for license information (AGPL). If you did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
