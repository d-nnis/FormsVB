use strict;
use warnings;
use Win32::GuiTest qw(:ALL);


{
	package Forms;
	
	sub new {
		my $class = shift;
		my $self = {};
		bless ($self, $class);
		# default settings
		$self->option(save_next => 1);
		return $self;
	}
	
	sub init {
		my $self = shift;
		my $target_window = "ReadSoft FORMS Manager";
		my @windows = FindWindowLike(undef, $target_window);
		die "Could not find $target_window\n" unless @windows;
		die "There is more than one $target_window running\n" if @windows > 1;
		my $mngr = $windows[0];
		print "found windows $mngr\n";
		SetForegroundWindow($mngr);
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
        my @valid_opts = qw(save_next);
        my $option;
        foreach my $opt_in (keys %opts_in) {
            warn "not recognized option: $opt_in" unless grep {$opt_in eq $_} @valid_opts;
            # settings anlegen $self->{confirm_execute} = 1 etc.
            $self->{$opt_in} = $opts_in{$opt_in};
        }
    }
	
	# set standard TRS, overwrite existing TRS
	sub TRS_std {
		my $self = shift;
		# open TRS
		SendKeys("%bt");
		# default TRS on empty
		SendKeys("{TAB}{ENTER}{DOWN}{ENTER}{ENTER}{ENTER}",50);
		print "std in TRS\n";
		# close or empty
		save_next() if get_option("save_next");
	}
	
	# changes Importfile & Fieldfile tp  "X(100)", requires standard TRS
	sub change_format_TRS {
		my $self = shift;
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
		save_next() if get_option("save_next");
	}
}

sub save_next {
	# save
	SendKeys("^s",35);
	# to next and load
	SendKeys("{TAB}{DOWN}{ENTER}",35);
	print "def saved";
}


1;