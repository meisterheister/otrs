# OTRS Modules Sources and Packages

This is a collection of OTRS modules source code and compiled packages. All the content here is developed and maintained by me.

For more information, please read the README.md in each module directory.

## OTRS Module Development Commands

The following is a list of handful commands for OTRS module development, debugging, checking and package building.

Run as root in the development machine only. **DO NOT RUN THE COMMANDS BELLOW IN A PRODUCTION SYSTEM.**

### Create Module Links

```
su otrs -c "/opt/otrs/dev/module-tools/link.pl /opt/otrs/dev/ModuleRootDir /opt/otrs" && \
su otrs -c "/opt/otrs/dev/module-tools/DatabaseInstall.pl -m ModuleName.sopm -a install" && \
su otrs -c "/opt/otrs/dev/module-tools/CodeInstall.pl -m ModuleName.sopm -a install"
```

### Remove Module Links

```
su otrs -c "/opt/otrs/dev/module-tools/DatabaseInstall.pl -m ModuleName.sopm -a uninstall" && \
su otrs -c "/opt/otrs/dev/module-tools/CodeInstall.pl -m ModuleName.sopm -a uninstall" && \
su otrs -c "/opt/otrs/dev/module-tools/remove_links.pl /opt/otrs"
```

### Refresh Environment

```
su otrs -c "/opt/otrs/bin/otrs.Console.pl Maint::Config::Rebuild" && \
su otrs -c "/opt/otrs/bin/otrs.Console.pl Maint::Cache::Delete" && \
service apache2 restart
```

### Debugging Modules

Set in `Kernel/Config/Files/ZZZAuto.pm`:

```perl
$Self->{'AdminEmail'} =  'user@example.com';
$Self->{'Frontend::TemplateCache'} =  '0';
$Self->{'LogModule'} =  'Kernel::System::Log::File';
$Self->{'MinimumLogLevel'} =  'debug';
$Self->{'Organization'} =  'OTRS5 DevLab';
$Self->{'SendmailModule'} =  'Kernel::System::Email::SMTPTLS';
$Self->{'SendmailModule::AuthPassword'} =  'somepassword';
$Self->{'SendmailModule::AuthUser'} =  'user@example.com';
$Self->{'SendmailModule::Port'} =  '587';
$Self->{'SendmailModule::Host'} =  'mail.example.com';
$Self->{'Ticket::Frontend::NeedAccountedTime'} =  '1';
$Self->{'Ticket::Frontend::TimeUnits'} = '(work units)';
```

```
sudo multitail /tmp/otrs.log /var/log/apache2/error.log
```

Use [OTRS Fred](https://github.com/OTRS/Fred) to debug UI.

```
cd /opt/otrs/dev/
git clone https://github.com/OTRS/Fred.git
su otrs -c "/opt/otrs/dev/module-tools/link.pl /opt/otrs/dev/Fred /opt/otrs"
```

Then reload UI and configure Fred at will. To uninstall it, just unlink the module.

### Lint

Use [OTRS code quality checker ](https://github.com/OTRS/otrscodepolicy) to verify a module code.

```
cd /opt/otrs/dev/
git clone https://github.com/OTRS/otrscodepolicy
cd /opt/otrs/dev/ModuleRootDir
/opt/otrs/dev/otrscodepolicy/bin/otrs.CodePolicy.pl -a
```

Example of an expected output:

```
root@devlab:/opt/otrs/dev/SupportQuota# /opt/otrs/dev/otrscodepolicy/bin/otrs.CodePolicy.pl -a
Found OTRS version 5.0.
This seems to be a module not copyrighted by OTRS AG. File copyright will not be changed.
[checked] Kernel/Config/Files/SupportQuota.xml
[checked] Kernel/Language/de_SupportQuota.pm
[checked] Kernel/Language/fr_SupportQuota.pm
[checked] Kernel/Language/pt_BR_SupportQuota.pm
[checked] Kernel/Output/HTML/OutputFilter/SupportQuota.pm
[checked] Kernel/Output/HTML/Templates/Standard/SupportQuotaAgent.tt
[checked] LICENSE.txt
[checked] README.md
[checked] SupportQuota.png
[checked] SupportQuota.sopm
[checked] doc/en/SupportQuota.pod
```

### Build Package/Repository

```
rm /opt/otrs/dev/packages/ModuleName*.opm
su otrs -c "/opt/otrs/bin/otrs.Console.pl Dev::Package::Build /opt/otrs/dev/ModuleRootDir/ModuleName.sopm /tmp"
su otrs -c "/opt/otrs/bin/otrs.Console.pl Dev::Package::RepositoryIndex /opt/otrs/dev/packages > /tmp/otrs.xml"
mv /tmp/ModuleName-x.x.x.opm /tmp/otrs.xml /opt/otrs/dev/packages
```
