use strict;
use warnings;
use forms_automate;

my $forms = Forms->new();
$forms->option(save_next => 1);
$forms->init();

foreach (0..9) {
	#$forms->TRS_std();
}

foreach (0..9) {
	$forms->change_format_TRS();
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