#!/usr/bin/env perl


#open the main vcf file
open (DATA, "$ARGV[0]");



#parse the data line by line
while($line=<DATA>){
	#insertions	
	if($line =~m/(.+)\t(\d+)\t\d+\t\-\t([ATGC]+)\t(\d+)\t.+\n/){
		$plasmid=$1;
		$pos=$2;
		$ref=".";
		$new=$3;
		$depth=$4;
		print "$plasmid\t$pos\t.\t$ref\t$new\t$depth\t.\n";
	}
	#deletions	
	if($line =~m/(.+)\t(\d+)\t\d+\t([ATGC]+)\t\-\t(\d+)\t.+\n/){
		$plasmid=$1;
		$pos=$2-1;
		$ref=$3;
		$depth=$4;
		print "$plasmid\t$pos\t.\tN$ref\tN\t$depth\t.\n";
	}
	#all other lines 
	if($line =~m/(.+)\t(\d+)\t\d+\t([ATGC]+)\t([ATGC]+)\t(\d+)\t.+\n/){
		$plasmid=$1;
		$pos=$2;
		$ref=$3;
		$new=$4;
		$depth=$5;
		print "$plasmid\t$pos\t.\t$ref\t$new\t$depth\t.\n";
	}
}
close DATA;

