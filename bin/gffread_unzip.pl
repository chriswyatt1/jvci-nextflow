#!/usr/bin/perl
use warnings;
use strict;

die "Needs the input sampleid, gff3 file and the fasta file\n" if (@ARGV!=3); 

#print "Script is running\n";

my $sample=$ARGV[0];

if ($ARGV[1] =~ m/.gz$/){
	`zcat $ARGV[1] > genome.fa`;
}

if ($ARGV[2] =~ m/.gz$/){
	`zcat $ARGV[2] > sample.gff3`;
	`cp sample.gff3 $sample\.gff_for_jvci.gff3`
}
else{
	`cp $ARGV[2] $sample\.gff_for_jvci.gff3`
}

`gffread -w $sample\.prot.fa -g genome.fa sample.gff3`
