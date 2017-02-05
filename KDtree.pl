#!/usr/bin/perl
#---in the txt ,every data is split by \t
use 5.006;
use strict;
use warnings;

my @KDtree=(
{ID=>'ID',c=>1,x=>1,y=>1}
);
#our $loop=0;
our @branch=(0);#KDTREE
our @add=(0);
our $Path='C:\Users\bob-surface\Desktop\test\\' ;
for(0..1000){
	$branch[$_]=0;
	$add[$_]=0;
}
our $file_num=0;my $cnt=0;
#---open file
for(1..20){
my $file_name=$Path.'use.txt';
my $open_flag = open USED,"<$file_name" ;
$open_flag ? print $file_name,"opened\n" : die("open failed!\n");
#---prefix

while(<USED>){
	my @insert = (split /\t/,$_);
		$KDtree[$cnt]{'ID'} = $insert[0];
		$KDtree[$cnt]{'c'} = $insert[1];
		$KDtree[$cnt]{'x'} = $insert[2];
		$KDtree[$cnt]{'y'} = $insert[3];
	$cnt++;
}
close USED;
print "read ok\n";
shift @KDtree;#out info
#my @res=&builds(0,'x',@KDtree);
#---bulid
&builds(0,'x',@KDtree);
print "bulid ok\n";

#my $ctr=0;
#for (0..@res){
#	print $res[$_]{'x'},"\t";
#	$ctr++;
#}
#print "\n",$ctr;
my $file_name2=$Path.'index.txt';
my $open_flag2 = open INDEX,">$file_name2" ;
print "open";
$open_flag2 ? print $file_name2,"opened\n" : die("open failed!\n");
foreach (@branch){
	print INDEX $_,"\n";
}
close INDEX;

}

sub builds{
	print "building...\n";
	my $loop=shift @_;
	my $flag=shift @_;
	print 'flag==',$flag,"\n";
	my @array=@_;
	print $loop,"==loop\t";
	#when the lastest amount of elements less than 10
	if($#array<10){
		my $str = 'file'.$file_num.'.txt';
		$branch[2**$loop+$add[$loop]]=$str;
		$file_num++;
		$add[$loop]++;
		&wrfile($str,@array);
		return @array;
		}
	#write to leaf
	my @tree1=&arrange($flag,@array);
	my $new_flag;
	if($flag eq 'y'){ 
		$new_flag='x';
		}else{ 
		$new_flag='y';
		}
	if($flag eq $new_flag){die("flag error\n");}
	#get the middle of the array
	my $mid= $tree1[$#tree1/2]{$flag};
	#print $tree1[0]{$flag};
	chomp($mid);
	print "mid==",($mid);
	#print grep{($$_{$flag})<=$mid}@tree1;
	my @tree_l=grep{($$_{$flag})<=$mid} @tree1;
	my @tree_r=grep{($$_{$flag})>$mid} @tree1;
	print "return\n";
	
	$branch[2**$loop+$add[$loop]]=$mid;
	$add[$loop]++;
	return &builds($loop+1,$new_flag,@tree_l),&builds($loop+1,$new_flag,@tree_r);
	#return (&bulids($new_flag,grep{($$_{$flag})<=$mid} @tree1),&bulids($new_flag,grep{($$_{$flag})>$mid} @tree1));
}

sub wrfile{
	my $createfile=$Path."data\\".shift @_;
	my @data=@_;
	my $cte_flag=open CRT ,">$createfile";
	$cte_flag ? print $createfile,"opened\n" : die("open failed!\n");
	foreach (@data){
		print CRT $$_{'ID'}."\n";
		print CRT $$_{'c'}."\n";
		print CRT $$_{'x'}."\n";
		print CRT $$_{'y'}."\n";
	}
	close CRT;
}
#bubble sort by the flag.(x or y)
sub arrange{
	#print "entered\n";
	my $flag=shift @_;
	my @array=@_;
	for(my $i=1;$i<$#array;$i++){
	for(my $j=$i;$j<$#array;$j++){
		if($array[$i]{$flag}>$array[$j]{$flag}){
		my @tmp_array=($array[$i]{'ID'},$array[$i]{'c'},$array[$i]{'x'},$array[$i]{'y'});
		$array[$i]{'ID'}=$array[$j]{'ID'};
		$array[$i]{'c'}=$array[$j]{'c'};
		$array[$i]{'x'}=$array[$j]{'x'};
		$array[$i]{'y'}=$array[$j]{'y'};

		$array[$j]{'ID'}=$tmp_array[0];
		$array[$j]{'c'}=$tmp_array[1];
		$array[$j]{'x'}=$tmp_array[2];
		$array[$j]{'y'}=$tmp_array[3];
		}
	}
	}
	return @array;
}