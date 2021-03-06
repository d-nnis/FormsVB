use strict;
use warnings;
use Win32::GuiTest qw (:ALL);
use Win32::Clipboard;
use feature qw(switch);
use Essent;
#use Win32::GuiTest qw(FindWindowLike);


{
	package Forms;
	
	sub new {
		my $class = shift;
		my $self = {};
		bless ($self, $class);
		# default settings
		$self->option(save_next => 1, shell => 1, wait => 60);
		#@{$self->{a} = ();
		return $self;
	}
	
	sub init {
		my $self = shift;
		my $target_window = "ReadSoft FORMS Manager";
		my @windows = Win32::GuiTest::FindWindowLike(undef, $target_window);
		#my @windows = FindWindowLike(undef, $target_window);
		die "Could not find $target_window\n" unless @windows;
		die "There is more than one $target_window running\n" if @windows > 1;
		$self->{mngr} = $windows[0];
		$self->{windowtitle} = Win32::GuiTest::GetWindowText($self->{mngr});
		# " 1971148 ~~ ReadSoft FORMS Manager - [RB_FK_03 [AKTIV]]"
		print "found window $self->{mngr} ~~ $self->{windowtitle}\n";
		#Process::confirm();
		Win32::GuiTest::SetForegroundWindow($self->{mngr});
	}
	
    sub get_option {
        my $self = shift;
        my $option = shift;
        return $self->{$option};
    }
	
    sub option {
        my $self = shift;
        if (@_ % 2 != 0) {
            if (@_ > 1) {
                #croak "usage: tie \@array, $_[0], filename, [option => value]...";
                warn "usage: option [option => value]\n";
            } else {
                #return ($_[0] =~ /$regex/ && $_[0] !~ /^\s*\#/ ? 1 : 0);
                return ($self->{$_[0]} ? $self->{$_[0]} : warn "option $_[0] not recognized");
            }
        }
        my (%opts_in) = @_;
        my @valid_opts = qw(save_next shell wait);
        my $option;
        foreach my $opt_in (keys %opts_in) {
            warn "not recognized option: $opt_in" unless grep {$opt_in eq $_} @valid_opts;
            # settings anlegen $self->{confirm_execute} = 1 etc.
            $self->{$opt_in} = $opts_in{$opt_in};
        }
    }
	
	sub delInput {
		my $self = shift;
		$self->init() if $self->option("shell");
		my $wait = $self->get_option("wait");
		print "Shift+Enter\n";
		Win32::GuiTest::SendKeys("+{DELETE}",$wait);
		print "Shift+Enter\n";
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "Enter\n";
		Win32::GuiTest::SendKeys("{LEFT}",$wait);
		print "Left\n";
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "Enter\n";
	}
	
	sub std1 {
		my $self = shift;
		$self->init() if $self->option("shell");
		$self->option(save_next => 0);
		$self->TRS_std();
		$self->change_format_TRS();
		#$self->TRS_length_Importfile(100);
		#$self->TRS_length_Fieldfile(100);
		$self->form_def_einst();
		$self->save();
	}
	
	sub std2 {
		my $self = shift;
		$self->init() if $self->option("shell");
		$self->option(save_next => 0);
		$self->TRS_std();
		$self->change_format_TRS2();
		#$self->TRS_length_Exportfile(100);
		#$self->TRS_length_Importfile(100);
		#$self->TRS_length_Fieldfile(100);
		$self->form_def_einst();
		$self->save();
	}
	
	sub std3 {
		my $self = shift;
		$self->init() if $self->option("shell");
		$self->option(save_next => 0);
		$self->TRS_std();
		$self->change_format_TRS3();
		#$self->TRS_length_Exportfile(100);
		#$self->TRS_length_Importfile(100);
		#$self->TRS_length_Fieldfile(100);
		$self->form_def_einst();
		$self->save();
	}
	
	## ci: continue item
	sub read_item {
		my $self = shift;
		my $wait = $self->get_option("wait");
		my $clip = Win32::Clipboard();
		$clip->Empty();
		$self->init() if $self->option("shell");
		Win32::GuiTest::SendKeys("{F6}{TAB}", $wait);
		Win32::GuiTest::SendKeys("^c", $wait*3);
		my $val = $clip->Get();
		return $val;
		
	}
	
	sub write_item {
		my $self = shift;
		my $varname = shift;
		Win32::GuiTest::SendKeys($varname,$self->get_option("wait"));
		Win32::GuiTest::SendKeys("{ENTER}", $self->get_option("wait"));
	}
	
	sub cia {
		my $self = shift;
		my $varname = $self->read_item();
		my ($var,$let) = $varname =~ /(.+)(\w)$/;
		given ($let) {
			when ('a') {$let = 'b'}
			when ('b') {$let = 'c'}
			when ('c') {$let = 'd'}
			when ('d') {$let = 'e'}
			when ('e') {$let = 'f'}
			when ('f') {$let = 'g'}
			when ('g') {$let = 'h'}
			when ('h') {$let = 'i'}
			when ('i') {$let = 'j'}
			when ('j') {$let = 'k'}
			when ('k') {$let = 'l'}
			when ('l') {$let = 'm'}
			when ('m') {$let = 'n'}
			when ('n') {$let = 'o'}
			when ('o') {$let = 'p'}
			when ('p') {$let = 'q'}
			when ('q') {$let = 'r'}
			when ('r') {$let = 's'}
			when ('s') {$let = 't'}
			when ('t') {$let = 'u'}
			when ('u') {$let = 'v'}
			when ('v') {$let = 'w'}
			when ('w') {$let = 'x'}
			when ('x') {$let = 'y'}
			when ('y') {$let = 'z'}
			default {
				warn "out of range (cia)\n";
				die unless Process::confirmJN;
			}
		}
		$self->write_item($var.$let);
	}
	
	# St�rzeichen Value �ndern/ setzen
	sub mark_stoerzeichen {
		my $self = shift;
		my $stoerz_val = shift;
		my $wait = $self->get_option("wait");
		my $clip = Win32::Clipboard();
		Win32::GuiTest::SendKeys("{Enter}");
		Win32::GuiTest::SendKeys("^c", $wait*3);
		my $Kategorie = $clip->Get();
		die unless $Kategorie eq 1;
		Win32::GuiTest::SendKeys("^{TAB}", $wait);
		Win32::GuiTest::SendKeys("{TAB}{TAB}{SPACE}{TAB}", $wait);
		Win32::GuiTest::SendKeys($stoerz_val, $wait);
		Win32::GuiTest::SendKeys("{ENTER}{TAB}{DOWN}");
	}
	
	sub ci1 {
		my $self = shift;
		my $varname = $self->read_item();
		my ($var,$dig) = $varname =~ /(.+)(\d{2})\w$/;
		$dig++;
		#$dig = Data::addzeros($dig, 2);
		$dig = Data::addzeros($dig, 3);
		$self->write_item($var.$dig."a");
	}
	
	sub form_def_einst {
		my $self = shift;
		Win32::GuiTest::SendKeys("%bf", $self->get_option("wait"));
		Win32::GuiTest::SendKeys("k{ENTER}",$self->get_option("wait"));
	}
	
	# set standard TRS, overwrite existing TRS
	sub TRS_std {
		my $self = shift;
		my $wait = $self->get_option("wait");
		# open TRS
		Win32::GuiTest::SendKeys("%bt", $wait);
		# default TRS on empty
		Win32::GuiTest::SendKeys("{TAB}{ENTER}{DOWN}{ENTER}{ENTER}{ENTER}",$wait);
		print "std in TRS\n";
		# close or empty
		$self->save_next() if $self->get_option("save_next");
	}
	
	sub save_TRS_file {
		my $self = shift;
		$self->init() if $self->option("shell");
		$self->option(save_next => 0);
		my $wait = $self->get_option("wait");
		# "ReadSoft FORMS Manager - [RB_FK_03 [AKTIV]]"
		my ($def) = $self->{windowtitle} =~ /ReadSoft FORMS Manager - \[(.{1,11}) \[I?N?AKTIV\]\]/;
		print "Definition: $def\n";
		my $path = "i:\\forms\\jobs\\TRS\\";
		# open TRS-export-dialog
		Win32::GuiTest::SendKeys("%bx", $wait*4);
		# enter name
		Win32::GuiTest::SendKeys("$path", $wait/4);
		Win32::GuiTest::SendKeys("$def", $wait/4);
		#Process::confirm;
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "TRS-file saved: $def\n";
		# overwrite-dialog?
		my $target_child = "Speichern unter";
		my @windows_child = Win32::GuiTest::FindWindowLike(undef, $target_child);
		if (@windows_child) {
			print "Overwrite: $target_child\n";
			Win32::GuiTest::SendKeys("{LEFT}{ENTER}",$wait);
		}
	}
	
	# changes Importfile & Fieldfile tp  "X(100)", requires standard TRS
	sub change_format_TRS {
		my $self = shift;
		my $length = shift || 100;
		my $wait = $self->get_option("wait");
		# open TRS
		Win32::GuiTest::SendKeys("%bt", $wait);
		# select #Importfile
		foreach (1..11) {
			Win32::GuiTest::SendKeys("{DOWN}",$wait);	
		}
		# find properties button
		foreach (1..15) {
			Win32::GuiTest::SendKeys("{TAB}",$wait);	
		}
		# Format field
		Win32::GuiTest::SendKeys("{ENTER}{TAB}{TAB}",$wait);
		# enter "X($length)"
		#Win32::GuiTest::SendKeys("{X}{(}100{)}", $wait);
		Win32::GuiTest::SendKeys("{X}{(}($length){)}", $wait);
		# length field
		Win32::GuiTest::SendKeys("{TAB}{TAB}{TAB}{TAB}",$wait);
		Win32::GuiTest::SendKeys($length);
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "importfile changed\n";
		
		# select Fieldfile
		Win32::GuiTest::SendKeys("{DOWN}{DOWN}",$wait);
		# find properties button
		foreach (1..15) {
			Win32::GuiTest::SendKeys("{TAB}",$wait);	
		}
		# Format field
		Win32::GuiTest::SendKeys("{ENTER}{TAB}{TAB}",$wait);
		# enter "X(100)"
		Win32::GuiTest::SendKeys("{X}{(}($length){)}", $wait);
		# length field
		Win32::GuiTest::SendKeys("{TAB}{TAB}{TAB}{TAB}",$wait);
		# enter "100"
		Win32::GuiTest::SendKeys($length, $wait);
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "fieldfile changed\n";
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		$self->save_next() if $self->get_option("save_next");
	}

	# changes Importfile & Fieldfile tp  "X(100)", requires standard TRS
	sub change_format_TRS2 {
		my $self = shift;
		my $length = shift || 100;
		my $wait = $self->get_option("wait");
		# open TRS
		Win32::GuiTest::SendKeys("%bt", $wait);
		
		# select #Exportfile
		foreach (1..9) {
			Win32::GuiTest::SendKeys("{DOWN}",$wait);	
		}
		#select properties button
		foreach (1..15) {
			Win32::GuiTest::SendKeys("{TAB}",$wait);	
		}
		# Format field
		Win32::GuiTest::SendKeys("{ENTER}{TAB}{TAB}",$wait);
		# enter "X($length)"
		Win32::GuiTest::SendKeys("{X}{(}($length){)}", $wait);
		# length field
		Win32::GuiTest::SendKeys("{TAB}{TAB}{TAB}{TAB}",$wait);
		Win32::GuiTest::SendKeys($length);
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "Exportfile changed\n";
		
		# select #Importfile
		foreach (1..2) {
			Win32::GuiTest::SendKeys("{DOWN}",$wait);	
		}
		# select properties button
		foreach (1..15) {
			Win32::GuiTest::SendKeys("{TAB}",$wait);	
		}
		# Format field
		Win32::GuiTest::SendKeys("{ENTER}{TAB}{TAB}",$wait);
		# enter "X($length)"
		Win32::GuiTest::SendKeys("{X}{(}($length){)}", $wait);
		# length field
		Win32::GuiTest::SendKeys("{TAB}{TAB}{TAB}{TAB}",$wait);
		Win32::GuiTest::SendKeys($length);
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "Importfile changed\n";
		
		# select Fieldfile
		Win32::GuiTest::SendKeys("{DOWN}{DOWN}",$wait);
		# find properties button
		foreach (1..15) {
			Win32::GuiTest::SendKeys("{TAB}",$wait);	
		}
		# Format field
		Win32::GuiTest::SendKeys("{ENTER}{TAB}{TAB}",$wait);
		# enter "X(100)"
		Win32::GuiTest::SendKeys("{X}{(}($length){)}", $wait);
		# length field
		Win32::GuiTest::SendKeys("{TAB}{TAB}{TAB}{TAB}",$wait);
		# enter "100"
		Win32::GuiTest::SendKeys($length, $wait);
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "Fieldfile changed\n";
		
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		$self->save_next() if $self->get_option("save_next");
	}
	
	sub change_format_TRS3 {
		my $self = shift;
		my $length = shift || 150;
		my $wait = $self->get_option("wait");
		# open TRS
		Win32::GuiTest::SendKeys("%bt", $wait);
		
		# ## select #Exportfile
		# foreach (1..9) {
			# Win32::GuiTest::SendKeys("{DOWN}",$wait);	
		# }
		# #select properties button
		# foreach (1..15) {
			# Win32::GuiTest::SendKeys("{TAB}",$wait);	
		# }
		# # Format field
		# Win32::GuiTest::SendKeys("{ENTER}{TAB}{TAB}",$wait);
		# # enter "X($length)"
		# Win32::GuiTest::SendKeys("{X}{(}($length){)}", $wait);
		# # length field
		# Win32::GuiTest::SendKeys("{TAB}{TAB}{TAB}{TAB}",$wait);
		# Win32::GuiTest::SendKeys($length);
		# Win32::GuiTest::SendKeys("{ENTER}",$wait);
		# print "Exportfile changed\n";
		
		## select #Importfile
		# foreach (1..2) {
			# Win32::GuiTest::SendKeys("{DOWN}",$wait);	
		# }
		foreach (1..11) {
			Win32::GuiTest::SendKeys("{DOWN}",$wait);	
		}
		# select properties button
		foreach (1..15) {
			Win32::GuiTest::SendKeys("{TAB}",$wait);	
		}
		# Format field
		Win32::GuiTest::SendKeys("{ENTER}{TAB}{TAB}",$wait);
		# enter "X($length)"
		Win32::GuiTest::SendKeys("{X}{(}($length){)}", $wait);
		# length field
		Win32::GuiTest::SendKeys("{TAB}{TAB}{TAB}{TAB}",$wait);
		Win32::GuiTest::SendKeys($length);
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "Importfile changed\n";
		
		# ## select Fieldfile
		# Win32::GuiTest::SendKeys("{DOWN}{DOWN}",$wait);
		# # find properties button
		# foreach (1..15) {
			# Win32::GuiTest::SendKeys("{TAB}",$wait);	
		# }
		# # Format field
		# Win32::GuiTest::SendKeys("{ENTER}{TAB}{TAB}",$wait);
		# # enter "X(100)"
		# Win32::GuiTest::SendKeys("{X}{(}($length){)}", $wait);
		# # length field
		# Win32::GuiTest::SendKeys("{TAB}{TAB}{TAB}{TAB}",$wait);
		# # enter "100"
		# Win32::GuiTest::SendKeys($length, $wait);
		# Win32::GuiTest::SendKeys("{ENTER}",$wait);
		# print "Fieldfile changed\n";
		
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		$self->save_next() if $self->get_option("save_next");
	}
	
	
	sub save_next {
		my $self = shift;
		$self->save();
		$self->next();
	}
	
	sub save {
		my $self = shift;
		# save
		Win32::GuiTest::SendKeys("^s",$self->get_option("wait"));
		print "def saved\n";
	}
	
	sub next {
		my $self = shift;
		# to next and load
		Win32::GuiTest::SendKeys("{TAB}{DOWN}{ENTER}",$self->get_option("wait"));
	}
}




1;