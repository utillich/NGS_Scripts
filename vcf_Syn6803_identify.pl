#!/usr/bin/env perl

#open the flatfile exported from cynobase and copy all data into the array "@catdata": 
open (CATDATA, "category_e.tsv");
while($catline=<CATDATA>){
push (@catdata, $catline);
}
close CATDATA;


#print the header
print "location\tAbs-Position\tDepth\tRef base\tnew base\tmutation type\tGene\tRef codon\tnew codon\tRef AS\tnew AS\tAS position\tgene length\tfunction\tcategory\tsubcategory\turl\n";


#open the submited file with mutation positions 
open (DATA, "@ARGV");
#parse the data line by line
while($line=<DATA>){

	#identify lines containing mutation information and extract needed data
	if($line =~m/(.+)\t(\d+)\t\.+\t(.*)\t(.+)\t(.+)\t.+\t(.+)\n/){
		$location=$1;
		$position=$2;
		$ref=$3;
		if($ref eq ""){$ref="-";}
		$alt=$4;
		if($alt eq "A,C,G,T"){$alt="-"; $ref=substr($ref,1,length($ref));}
		$qual=$5;
		$info=$6;
		$foundsomething=0;

	#############################################################################
	#############	search in $info to extract data added by snpEff #############
	if($info =~m/.+NON_SYNONYMOUS_CODING\((.+?)\|(.*?)\|(.+?)\/(.+?)\|(\D)(\d+)(\D)\|(\d+?)\|(.+?)\|.*?\|.*?\|(.+?)\|\)/){
		$severity=$1;
		$type=$2;
		$old_codon=$3;
		$new_codon=$4;
		$old_AS=$5;
		$AS_position=$6;
		$new_AS=$7;
		$AS_length=$8;
		$gene_name=$9;
		$gene_id=$10;
		print "$location\t$position\t$qual\t$ref\t$alt\t";
		print "AS change\t$gene_name\t$old_codon\t$new_codon\t$old_AS\t$new_AS\t$AS_position\t$AS_length\t";
		&printcategory($gene_id);
		$foundsomething++;
		}
	if($info =~m/.+\,SYNONYMOUS_CODING\((.+?)\|(.*?)\|(.+?)\/(.+?)\|(\D)(\d+)\|(\d+?)\|(.+?)\|.*?\|.*?\|(.+?)\|\)/){
		$severity=$1;
		$type=$2;
		$old_codon=$3;
		$new_codon=$4;
		$old_AS=$5;
		$AS_position=$6;
		$new_AS=$5;
		$AS_length=$7;
		$gene_name=$8; 
		$gene_id=$9;
		print "$location\t$position\t$qual\t$ref\t$alt\t";
		print "silent mutation\t$gene_name\t$old_codon\t$new_codon\t$old_AS\t$new_AS\t$AS_position\t$AS_length\t";
		&printcategory($gene_id);
		$foundsomething++;
		}
	if($info =~m/.+\,FRAME_SHIFT\((.+?)\|.*?\|(.+?)\|(.+?)\|(\d+?)\|(.+?)\|.*?\|.*?\|(.+?)\|.*?\)/){
		$severity=$1;
		$direction=$2;
		$AS_position=$3;
		$AS_length=$4;
		$gene_name=$5; 
		$gene_id=$6;
		print "$location\t$position\t$qual\t$ref\t$alt\t";
		print "frameshift mutation\t$gene_name\t\t\t\t\t$AS_position\t$AS_length\t";
		&printcategory($gene_id);
		$foundsomething++;
		}
	if($info =~m/.+CODON_CHANGE_PLUS_CODON_INSERTION\((.+?)\|(.*?)\|(.+?)\/(.+?)\|(\D)(\d+)(\D+?)\|(\d+?)\|(.+?)\|.*?\|.*?\|(.+?)\|.*?\)/){
		$severity=$1;
		$type=$2;
		$old_codon=$3;
		$new_codon=$4;
		$old_AS=$5;
		$AS_position=$6;
		$new_AS=$7;
		$AS_length=$8;
		$gene_name=$9; 
		$gene_id=$10;
		print "$location\t$position\t$qual\t$ref\t$alt\t";
		print "AS change and AS insertion\t$gene_name\t$old_codon\t$new_codon\t$old_AS\t$new_AS\t$AS_position\t$AS_length\t";
		&printcategory($gene_id);
		$foundsomething++;
		}
	if($info =~m/.+STOP_LOST\((.+?)\|(.+?)\|(.+?)\/(.+?)\|(\D)(\d+?)(\D)\|(\d+?)\|(.+?)\|.*?\|.*?\|(.+?)\|\)/){
		$severity=$1;
		$type=$2;
		$old_codon=$3;
		$new_codon=$4;
		$old_AS=$5;
		$AS_position=$6;
		$new_AS=$7;
		$AS_length=$8;
		$gene_name=$9;
		$gene_id=$10;
		print "$location\t$position\t$qual\t$ref\t$alt\t";
		print "Stop lost\t$gene_name\t$old_codon\t$new_codon\t$old_AS\t$new_AS\t$AS_position\t$AS_length\t";
		&printcategory($gene_id);
		$foundsomething++;
		}
	if($info =~m/.+CODON_CHANGE_PLUS_CODON_DELETION\((.+?)\|.*?\|(.+?)\/(.+?)\|(\D+)(\d+)(\D+)\|(\d+?)\|(.+?)\|.*?\|.*?\|(.+?)\|\d*?\)/){ 
		$severity=$1;
		$type="";
		$old_codon=$2;
		$new_codon=$3;
		$old_AS=$4;
		$AS_position=$5;
		$new_AS=$6;
		$AS_length=$7;
		$gene_name=$8;
		$gene_id=$9;
		print "$location\t$position\t$qual\t$ref\t$alt\t";
		print "Codon Changed and Codon deleted\t$gene_name\t$old_codon\t$new_codon\t$old_AS\t$new_AS\t$AS_position\t$AS_length\t";
		&printcategory($gene_id);
		$foundsomething++;
		}
	

	# no examples in data found so far
#	if($info =~m/.+START_GAINED\(.+?\).+/){ print "prev line: START_GAINED- SOMETHING NEW FOUND!!! UPDATE code to extract data\n";}
#	if($info =~m/.+START_LOST\(.+?\).+/){ print "prev line: START_LOST-SOMETHING NEW FOUND!!! UPDATE code to extract data\n";}
#	if($info =~m/.+SYNONYMOUS_START\(.+?\).+/){ print "prev line: SYNONYMOUS_START.SOMETHING NEW FOUND!!! UPDATE code to extract data\n";}
#	if($info =~m/.+\,CODON_CHANGE\(.+?\).+/){ print "prev line: CODON_CHANGE-SOMETHING NEW FOUND!!! UPDATE code to extract data\n";}
#	if($info =~m/.+\,CODON_DELETION\(.+?\).+/){ print "prev line: CODON_DELETION-SOMETHING NEW FOUND!!! UPDATE code to extract data\n";}
#	if($info =~m/.+\,CODON_INSERTION\(.+?\).+/){ print "prev line: CODON_INSERTION-SOMETHING NEW FOUND!!! UPDATE code to extract data\n";}
#	if($info =~m/.+NON_SYNONYMOUS_START\(.+?\).+/){ print "prev line: NON_SYNONYMOUS_START-SOMETHING NEW FOUND!!! UPDATE code to extract data\n";}
#	if($info =~m/.+RARE_AMINO_ACID\(.+?\).+/){ print "prev line: RARE_AMINO_ACID-SOMETHING NEW FOUND!!! UPDATE code to extract data\n";}

	#no relevant info found in snpEFF data
	if($foundsomething eq 0){
		print "$location\t$position\t$qual\t$ref\t$alt\t";
		print "intergenic\tintergenic\t\t\t\t\t\t\t";
		print "\t\t\t\n";
		}

#############################################################################
####### subroutine to to determine and print the category & function  #######
sub printcategory {
	foreach(@catdata){
		if($_ =~m/"$_[0]"\t"(.+)"\t"(.+)"\t\n/){
		$function=$1;
		$category=$2;
		$subcategory="none";
		}
		if($_ =~m/"$_[0]"\t"(.+)"\t"(.+)"\t"(.+)"\n/){
		$function=$1;
		$category=$2;
		$subcategory=$3;
		}
	}
	print "$function\t$category\t$subcategory\thttp://genome.kazusa.or.jp/cyanobase/Synechocystis/genes/$_[0]\n";
	}
}
#############################################################################


}
close DATA;

