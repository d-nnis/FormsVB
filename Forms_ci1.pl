use warnings;
use strict;
use forms_automate;

my $forms = Forms->new();
$forms->option(wait=>10);
select(undef, undef, undef, 0.5); 
$forms->ci1();
