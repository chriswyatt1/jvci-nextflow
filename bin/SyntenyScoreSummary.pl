use warnings;
use strict;

# Script to calculate the present of a gene in synteny across all other species, and summarise the distance to break averaged across all species. 

print "Please be in folder with all the geneScore.tsv files\n";

my @files=`ls *.geneScore.tsv `;

my %score;
my %count;
my %lastR;

#Loop thru the files to get the synteny info.
foreach my $file (@files){
    #Get species name pairs
    chomp $file;
    my @split_name=split(/\./, $file);
    my $sp1=$split_name[0];
    my $sp2=$split_name[1];

    #Check if the last data support a orthologous pair for each gene. 
    # Count them once (covered_this_round), as some genes will have mutliple hits. 
    my $lastfile="$sp1\.$sp2\.last.filtered";
    open(my $lastin, "<", $lastfile)   or die "Could not open $lastfile\n";
    my %covered_this_round;
    while (my $lastline=<$lastin>){
        chomp $lastline;
        my @split=split("\t", $lastline);

        # If we have not seen this gene yet in this specific pairwise file:
        if ($covered_this_round{$split[0]}){
            #Ignore
        }
        else{
            #Else we can count it
            # If there is already a score:
            if($lastR{$sp1}{$split[0]}){
                $lastR{$sp1}{$split[0]}++;
            }
            else{
                $lastR{$sp1}{$split[0]}=1;
            } 

            #Then we must set covered in this round, so that we don't count it more than once
            $covered_this_round{$split[0]}="yes";
        }

    }

    #Now read file in (genescores for each pairwise):
    open(my $filein, "<", $file)   or die "Could not open $file\n";

    #Loop through the gene score file and split up the col data.
    while (my $line=<$filein>){
        chomp $line;

        my @split=split("\t", $line);
        my $sp_name=$split[0];
        my $gene=$split[1];
        my $val=$split[2];

        #Make sure the first line is the right species.
        if ($sp_name eq $sp1){

            #Calculate total scores
            # If there is already a score:
            if ($score{$sp1}{$gene}){
                my $old=$score{$sp1}{$gene};
                $score{$sp1}{$gene}=$val+$old;
            }
            # If there is not a score set yet. For sp1 and this gene.
            else{
                $score{$sp1}{$gene}=$val;
            }

            #Calculate total count
            # If there is already a count for this gene
            if ($count{$sp1}{$gene}){
                $count{$sp1}{$gene}++;
            }
            # If there is not yet a count score for this gene, add it.
            else{
                $count{$sp1}{$gene}=1;
            }
            
        }
    }
    close $filein;
}



foreach my $species (keys %score) {
    my $outname="$species\.SpeciesScoreSummary.txt";
    open(my $outhandle, ">", $outname)   or die "Could not open $outname\n";
    print $outhandle "Species\tgene\ttotal_score\tcount\taverage_score\tspecies_homologous_to\n";
    foreach my $gene (keys %{$score{$species}}) {
        my $average=$score{$species}{$gene}/$count{$species}{$gene};
        print $outhandle "$species\t$gene\t$score{$species}{$gene}\t$count{$species}{$gene}\t$average\t$lastR{$gene}\n";
    }
    close $outhandle;
}







