use warnings;
use strict;
use forms_automate;

my $forms = Forms->new();
$forms->option(wait=>20);
select(undef, undef, undef, 0.2);
$forms->delInput();


