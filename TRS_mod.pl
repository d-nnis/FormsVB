use strict;
use warnings;

use Win32::GuiTest qw (:ALL);

my $target_window = "ReadSoft FORMS Manager";

my @windows = FindWindowLike(undef, $target_window);
die "Could not find $target_window\n" unless @windows;
die "There is more than one $target_window running\n" if @windows > 1;
my $mngr = $windows[0];
print "found windows $mngr\n";
SetForegroundWindow($mngr);

foreach (0..9) {
	#TRS_std();
	#save_next();
}

foreach (0..9) {
	change_format_TRS();
	save_next();
}

# set standard TRS, overwrite existing TRS
sub TRS_std {
	# open TRS
	SendKeys("%bt");
	# default TRS on empty
	SendKeys("{TAB}{ENTER}{DOWN}{ENTER}{ENTER}{ENTER}",50);
	print "std in TRS\n";
	# close or empty
}

# changes Importfile & Fieldfile tp  "X(100)", requires standard TRS
sub change_format_TRS {
	# open TRS
	SendKeys("%bt");
	# select #Importfile
	foreach (1..11) {
		SendKeys("{DOWN}",35);	
	}
	# find properties button
	foreach (1..15) {
		SendKeys("{TAB}",35);	
	}
	# Format field
	SendKeys("{ENTER}{TAB}{TAB}",35);
	# enter "X(100)"
	SendKeys("{X}{(}100{)}");
	# length field
	SendKeys("{TAB}{TAB}{TAB}{TAB}",35);
	# enter "X(100)"
	SendKeys("100");
	SendKeys("{ENTER}",50);
	print "importfile changed\n";
	
	# select Fieldfile
	SendKeys("{DOWN}{DOWN}");
	# find properties button
	foreach (1..15) {
		SendKeys("{TAB}",35);	
	}
	# Format field
	SendKeys("{ENTER}{TAB}{TAB}",35);
	# enter "X(100)"
	SendKeys("{X}{(}100{)}");
	# length field
	SendKeys("{TAB}{TAB}{TAB}{TAB}",35);
	# enter "X(100)"
	SendKeys("100");
	SendKeys("{ENTER}",35);
	print "fieldfile changed\n";
	SendKeys("{ENTER}",35);
}

sub save_next {
	# save
	SendKeys("^s",35);
	# to next and load
	SendKeys("{TAB}{DOWN}{ENTER}",35);
	print "def saved";
}

__END__
## mouse-Action
my ($left, $top, $right, $bottom) = GetWindowRect($windows[0]);
# find the appropriate child window and click on  it
my @children = GetChildWindows($windows[0]);
my @texts = map {GetWindowText($_)} @children;
my @targets = ("V6FI_debla [AKTIV]");
foreach my $title (@targets) {
	my ($c) = grep {$title eq GetWindowText($_)} @children;
	my ($left, $top, $right, $bottom) = GetWindowRect($c);
	MouseMoveAbsPix(($right+$left)/2,($top+$bottom)/2);
	SendMouse("{LeftClick}");
	SendMouse("{LeftClick}");
	sleep(1);
}
printf "Result: %s\n", WMGetText($children[0]);

MouseMoveAbsPix($right-10,$top+10);  # this probably depends on the resolution
sleep(2);
SendMouse("{LeftClick}");



    #system("start notepad.exe");
    #sleep 3;
    #Win32::GuiTest::SendKeys("If you're reading this inside notepad,\n");
    #Win32::GuiTest::SendKeys("we might consider this test succesful.\n");
    #Win32::GuiTest::SendKeys("Now I'll send notepad an ALT{+}F4 to close\n");
    #Win32::GuiTest::SendKeys("it. Please wait.......");
    #sleep 1;
    #Win32::GuiTest::SendKeys(".");
    #sleep 1;
    #Win32::GuiTest::SendKeys(".");
    #sleep 1;
    #Win32::GuiTest::SendKeys(".");
    #Win32::GuiTest::SendKeys("%{F4}{TAB}{ENTER}");