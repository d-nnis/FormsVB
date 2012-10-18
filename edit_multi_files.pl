use strict;
use warnings;
use Essent;
use feature qw(say);

## config

my %config = File::readfile("i:\\vera6 2012\\process_control\\config_V6.csv", 'config');
my $readdir = "c:\\Programme\\Readsoft\\FORMS\\Jobs\\";
my $multifiles_extension = "JOB";
my $backup_extension = "COMMONBAK";
my $notequal_sign = "___NOT EQUAL___";
my $file_common = $readdir.$multifiles_extension.'.common';
##

#open array-files
my @file;

#@file = File::get_by_ext($readdir,$multifiles_extension);

@file = split /,/, $config{forms_jobs};

#vergleiche inhalt jeder Datei
#jede Zeile in gemeinsamen Speicher ablegen
my %content_file;
#$content_file{VL001_2} = ("VL001_2\n","[Interpret]\n", ...)

# performance tweak: content_common schon hier anlegen
foreach my $filename (@file) {
	next if 0;
	@{$content_file{$filename}} = File::readfile($readdir.$filename);
}

## TODO was, wenn Dateien verschieden viele Zeilen haben?

# file_line-number
my $file_linenum = 0;
#my %content_common;
my @content_common;
#$content_common{0} = "VL001_2\n";
foreach my $filename (keys %content_file) {
	foreach my $file_line (@{$content_file{$filename}}) {
		if (defined $content_common[$file_linenum]) {
			if ($content_common[$file_linenum] ne $file_line) {
				$content_common[$file_linenum] = $notequal_sign."\n";
				#my @content_common_line = split //, $content_common[$file_linenum];
				#my @file_line = split //, $file_line;
				#my $merge_line;
				#foreach my $i (0 .. $#content_common_line) {
				#	if ($content_common_line[$i] eq $file_line[$i]) {
				#		# Zeichen gleich
				#		$merge_line .= $content_common_line[$i];
				#	} else {
				#		# Zeichen nicht gleich
				#		
				#	}
				#	
				#}
			}
		} else {
			$content_common[$file_linenum] = $file_line;
		}
		$file_linenum++;
	}
	$file_linenum = 0;
}


File::writefile($file_common, @content_common);

say "\ncheck, alter and save common lines in $file_common\n\n";
my $edit_call = 'c:\Programme\Notepad++\notepad++.exe '. $file_common;
system($edit_call);
say "continue...";
die "terminate script\n" unless Process::confirmJN();

@content_common = File::readfile($readdir.$multifiles_extension.'.common');

## modify file-content
foreach my $file (keys %content_file) {
	## make one backup each before overwrite
	File::writefile($readdir.$file.'.'.$backup_extension, @{$content_file{$file}});
	## parse content_common
	#foreach my $file_line (@{$content_file{$file}}) {
	foreach $file_linenum ( 0 .. $#{$content_file{$file}}) {
		if ($content_common[$file_linenum] eq $notequal_sign."\n") {
			next;
		}
		${$content_file{$file}}[$file_linenum] = $content_common[$file_linenum];
	}
	File::writefile($readdir.$file, @{$content_file{$file}});
}

say "Find modifications in files.";
say "script end";

__END__


		#print "Value EXISTS, but may be undefined.\n" if exists  $hash{ $key };
		#print "Value is DEFINED, but may be false.\n" if defined $hash{ $key };
		#print "Value is TRUE at hash key $key.\n"     if         $hash{ $key };