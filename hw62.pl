use strict;
use warnings;
use feature qw(say);
use utf8;


$\="\n";
my ($result,$stack);

while(<>){
   $stack=toStack($_,[]);
   print join(",",@$stack);
   $result=computing($stack);
   print $result;
}

sub toStack{
   my ($line,$stack)=@_;
   my (@operStack,$oper,$num,$success,$success2);
   $line=~/\G\s*(-?\d*\.?\d*(?:e[+-]\d+)?)/gc;
   $num=$1;
   push @$stack,$num if $num=~/\d/;
   while(1){
      $success=$line=~/\G\s*([\/\*\+-\^])\s*/gc;
      $oper=$1;
      $line=~/\G(\d*\.?\d*(?:e[+-]\d+)?)/gc;
      $num=$1;
      if($success){
         if($oper ne '^'){
            my $bound=$#operStack;
            for(my $i=$bound;$i>=0;--$i){
               if (prior($operStack[$i],$oper)){
                  push @$stack,pop @operStack;
               }
            }
            push @operStack,$oper;
         }
      }

      if( $num=~/\d/){
         push @$stack,$num;
      }
      
      else{
         $success2=$line=~/\G\s*\(([^\(\)]*([\(\)]))/gc;
         last if !$success2;
         my $str=$1;
         my $left=1;
         my $right=0;
         if($2 eq ')'){
            ++$right;
         }
         else{
            ++$left;
         }
         while($left>$right){
            $line=~/\G([^\(\)]*([\(\)]))/gc;
            $str.=$1;
            if($2 eq ')'){
               ++$right;
            }
            else{
               ++$left;
            }
         }
         $str=substr($str,0,length($str)-1);
         $stack=toStack($str,$stack);   
      }

      if($success){
         push @$stack,$oper if $oper eq '^';
      }
   }
   @operStack=reverse @operStack;
   for my $tmp (@operStack){
      push @$stack,$tmp;
   }
   return $stack

}

sub prior{
   my ($f,$s)=@_;
   if($f eq '^'){
      $f=3;
   }
   elsif($f=~/[*\/]/){
      $f=2;
   }
   else{
      $f=1;
   }

   if($s eq '^'){
      $s=3;
   }
   elsif($s=~/[*\/]/){
      $s=2;
   }
   else{
      $s=1;
   }
   print $f;
   print $s;
   return 1 if $f>=$s;
   return 0;

}

sub computing{
   my $counter=0;
   my $OperationCounter=0;
   while($counter<=$#{$_[0]}){
     if ($_[0][$counter]eq'*'){
       $_[0][$counter]=$_[0][$counter-1]*$_[0][$counter-2];
       print $_[0][$counter];
       ++$OperationCounter;
       sdvizhka($_[0],$counter-1,$OperationCounter*2);
     }
     elsif($_[0][$counter]eq'/'){
       $_[0][$counter]=$_[0][$counter-1]/$_[0][$counter-2];
       print $_[0][$counter];
       ++$OperationCounter;
       sdvizhka($_[0],$counter-1,$OperationCounter*2);
     }
     elsif($_[0][$counter]eq'+'){
       $_[0][$counter]=$_[0][$counter-1]+$_[0][$counter-2];
       print $_[0][$counter];
       ++$OperationCounter;
       sdvizhka($_[0],$counter-1,$OperationCounter*2);
     }
     elsif($_[0][$counter]eq'-'){
       $_[0][$counter]=$_[0][$counter-2]-$_[0][$counter-1];
       print $_[0][$counter];
       ++$OperationCounter;
       sdvizhka($_[0],$counter-1,$OperationCounter*2);
     }
     elsif($_[0][$counter]eq'^'){
       $_[0][$counter]=$_[0][$counter-2] ** ($_[0][$counter-1]);
       print $_[0][$counter];
       ++$OperationCounter;
       sdvizhka($_[0],$counter-1,$OperationCounter*2);
     }
     ++$counter;
   }
   return $_[0][$#{$_[0]}];
 }
 
 sub sdvizhka{
   my $counter=$_[1];
   while($counter>=$_[2]){
     $_[0][$counter]=$_[0][$counter-2];
     --$counter;
   }
}
