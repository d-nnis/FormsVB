use strict;
use warnings;
use Win32::GuiTest qw (:ALL);
#use Win32::GuiTest qw(FindWindowLike);


{
	package Forms;
	
	sub new {
		my $class = shift;
		my $self = {};
		bless ($self, $class);
		# default settings
		$self->option(save_next => 1, shell => 1, wait => 50);
		return $self;
	}
	
	sub init {
		my $self = shift;
		my $target_window = "ReadSoft FORMS Manager";
		my @windows = Win32::GuiTest::FindWindowLike(undef, $target_window);
		#my @windows = FindWindowLike(undef, $target_window);
		die "Could not find $target_window\n" unless @windows;
		die "There is more than one $target_window running\n" if @windows > 1;
		my $mngr = $windows[0];
		print "found window $mngr\n";
		Win32::GuiTest::SetForegroundWindow($mngr);
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
	
	sub std1 {
		my $self = shift;
		$self->init() if $self->option("shell");
		$self->option(save_next => 0);
		$self->TRS_std();
		$self->change_format_TRS();
		$self->form_def_einst();
		$self->save();
	}
	
	## ci: continue item
	sub ci {
		my $self = shift;
		Win32::GuiTest::SendKeys("%bf");
	}
	
	sub form_def_einst {
		my $self = shift;
		Win32::GuiTest::SendKeys("%bf");
		Win32::GuiTest::SendKeys("k{ENTER}",$self->get_option("wait"));
	}
	
	# set standard TRS, overwrite existing TRS
	sub TRS_std {
		my $self = shift;
		my $wait = $self->get_option("wait");
		# open TRS
		Win32::GuiTest::SendKeys("%bt");
		# default TRS on empty
		Win32::GuiTest::SendKeys("{TAB}{ENTER}{DOWN}{ENTER}{ENTER}{ENTER}",$wait);
		print "std in TRS\n";
		# close or empty
		$self->save_next() if $self->get_option("save_next");
	}
	
	# changes Importfile & Fieldfile tp  "X(100)", requires standard TRS
	sub change_format_TRS {
		my $self = shift;
		my $length = shift || 100;
		my $wait = $self->get_option("wait");
		# open TRS
		Win32::GuiTest::SendKeys("%bt");
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
		#Win32::GuiTest::SendKeys("{X}{(}100{)}");
		Win32::GuiTest::SendKeys("{X}{(}($length){)}");
		# length field
		Win32::GuiTest::SendKeys("{TAB}{TAB}{TAB}{TAB}",$wait);
		Win32::GuiTest::SendKeys($length);
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "importfile changed\n";
		
		# select Fieldfile
		Win32::GuiTest::SendKeys("{DOWN}{DOWN}");
		# find properties button
		foreach (1..15) {
			Win32::GuiTest::SendKeys("{TAB}",$wait);	
		}
		# Format field
		Win32::GuiTest::SendKeys("{ENTER}{TAB}{TAB}",$wait);
		# enter "X(100)"
		Win32::GuiTest::SendKeys("{X}{(}($length){)}");
		# length field
		Win32::GuiTest::SendKeys("{TAB}{TAB}{TAB}{TAB}",$wait);
		# enter "100"
		Win32::GuiTest::SendKeys($length);
		Win32::GuiTest::SendKeys("{ENTER}",$wait);
		print "fieldfile changed\n";
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
		print "def saved";
	}
	
	sub next {
		my $self = shift;
		# to next and load
		Win32::GuiTest::SendKeys("{TAB}{DOWN}{ENTER}",$self->get_option("wait"));
	}
}




1;