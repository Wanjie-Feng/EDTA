#!/usr/bin/perl -w
use strict;

my $usage = "";
my $fasta = $ARGV[0];

open FA, "<$fasta" or die "\nInput not found!\n$usage";
$/ = "\n>";
my $num = 0;
my %data;
while (<FA>){
	s/>//g;
	$num = sprintf("%08d", $num);
	my ($id, $seq) = (split /\n/, $_, 2);
	my $name = (split /\s+/, $id)[0];
	$seq =~ s/\s+//g;
	my ($fam, $class) = ($1, $2) if $name =~ /^(.*)#(.*)$/;
	#retain LTR-INT info for LTR sequences
	if ($class =~ /LTR/i){
		my ($loc, $part) = ('', '');
		($loc, $part) = ($1, $2) if $fam =~ /^(.*)_(LTR|INT)$/i;
		if (exists $data{$loc}){
			$data{$loc} .= ">TE_${num}_$part#$class\n$seq\n";
			} else {
			$data{$loc} = ">TE_${num}_$part#$class\n$seq\n";
			$num++;
			}
		} else {
		$data{$fam} = ">TE_${num}#$class\n$seq\n";
#	print ">TE_$num#$class\n$seq\n";
		$num++;
		}
	}
close FA;

foreach my $fam (sort{$data{$a} cmp $data{$b}} (keys %data)){
	print $data{$fam};
	}

#>Chr1:5149821..5149977_LTR#LTR/unknown
#>Chr1:26987256..26991447_LTR#LTR/Gypsy