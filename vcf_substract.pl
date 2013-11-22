#!/usr/bin/env perl


#open the main vcf file
open (DATA, "$ARGV[0]");

#open reference vcf file
open (REFDATA, "$ARGV[1]");
while($refline=<REFDATA>){push (@refdata, $refline);}
close REFDATA;

#open File logging Info
open (LOGFILE, '>SubstractPl.log');




#parse the data line by line
while($line=<DATA>){
	#identify lines containing position data
	#NC_000911	98129	.	A	G	20	.
	if($line =~m/(.+)\t(\d+)\t\.+\t.+\t.+\t.+\n/){
		$plasmid=$1;
		$mainpos=$2;
		$duplicate=0;
		$i=0;
		#search for same positions in reference file
		foreach(@refdata){
			$i++;
			if($_ =~m/(.+)\t(\d+)\t\.+\t.+\t.+\t.+\n/){
				if($1 eq $plasmid & $2 eq $mainpos){
					$duplicate=1;
					#note which mutations where removed by the programm
					push (@mutremoved, $i);
					print LOGFILE "REMOVED line: ".$i." \t position: ".$2."\n";
				}
			}
		}
		#if the same postion was not found in the reference print the line
		if($duplicate eq 0){print "$line"}
	}
	#print all lines without position data
	else {print "$line";}
}
close DATA;



#add Info about lines NOT removed
$i=0;
$mutwasremoved=0;
foreach(@refdata){
	$i++;
	foreach(@mutremoved){
		if($i eq $_) {$mutwasremoved=1;}
	}
	if($mutwasremoved eq 0){push (@notremoved, $i);}
	$mutwasremoved=0;
}
print LOGFILE "\nThe following WT Mutation Lines were not removed: @notremoved \n";
close LOGFILE;

