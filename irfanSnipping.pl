use warnings;
use strict;
use irfanview_automate;

my $irfan = Irfan->new();
$irfan->option(wait=>10);
select(undef, undef, undef, 0.2);
$irfan->get_crop();


## sample-output
# Modul essent.pm
# found window 1900768
# Window-Title:scp_dilate82012-10-18_135254.jpg - IrfanView (Selection: 411, 176; 159 x 114; 1.395)
##