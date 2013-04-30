use warnings;
use strict;
use irfanview_automate;

my $irfan = Irfan->new();
$irfan->option(wait=>10);
select(undef, undef, undef, 0.2);
$irfan->get_crop();
