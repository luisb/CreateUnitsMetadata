#!/usr/bin/perl

# get list of directory (paths) 
@dirs = `find /mnt/cbsrtitan/docWORKS/IN/UCR-NP/Production/SacUnion -mindepth 2 -maxdepth 2 -type d -exec echo "{}" \\;`;

foreach (@dirs) {
	chomp;

	$cur_dir = $_;
	(my $reel = $_) =~ s/^.*\///;

	# copy template to current reel directory
	`cp /mnt/cbsrtitan/docWORKS/IN/UCR-NP/Production/SacUnion/UNITS_METADATA.xml $cur_dir`;

	# newfile contains fullpath to file name	
	$newfile = $cur_dir . "/" . "UNITS_METADATA.xml";
	
	# array of lines from template file
	my @inline;

	# parse template file and push into array
	open (INFILE, '<', $newfile) or die "Could not open file '$newfile' $! for reading.";
	while (my $line = <INFILE>) {
		push(@inline, $line);
	}
	close INFILE;

	# parse array and write into file, replacing template reel number with current reel number
	open (OUTFILE,'>', $newfile) or die "Could not open file '$newfile' $! for writing.";
	foreach (@inline) {
		my $line = $_;
		if ($line =~ /<reel>/) {
			$line =~ s/00000000000/$reel/;
		}
		print OUTFILE $line;
	}
	close OUTFILE;

}

