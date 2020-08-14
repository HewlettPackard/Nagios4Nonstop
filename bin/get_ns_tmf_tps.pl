########################################################################################
# Copyright 2020 Hewlett Packard Enterprise Development LP. All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
# 
#    1. Redistributions of source code must retain the above copyright notice, this list of
#       conditions and the following disclaimer.
# 
#    2. Redistributions in binary form must reproduce the above copyright notice, this list
#       of conditions and the following disclaimer in the documentation and/or other materials
#       provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY Hewlett Packard Enterprise Development LP ``AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Hewlett Packard Enterprise Development LP OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# The views and conclusions contained in the software and documentation are those of the
# authors and should not be interpreted as representing official policies, either expressed
# or implied, of Hewlett Packard Enterprise Development LP.
########################################################################################
use strict;
use Getopt::Long;
use File::Basename;

chdir(dirname($0)) or die "Coun't chdir from this path $0\n";

my $warning=60;
my $critical=80;
my $verbose;
my $ret_code=0;
my $cpu;
my $result;
my $cpu_number;
my $hostaddress;

$result = GetOptions(
            "warning=i" => \$warning,    # numeric
            "critical=i"   => \$critical,      # string
            "hostaddress=s"   => \$hostaddress,      # string
            "verbose"  => \$verbose
          );

our @mem_usage=();
our $status="TPS OK";
our $perf_data="";
our $main_data="";
my $index=0;
my $out;

#$out=`expect /usr/local/ns/ns_meascom_output.exp`;
#$out=`perl /usr/local/ns/get_stats.pl -H $hostaddress`;
$out=`perl ./get_stats.pl -H $hostaddress`;

my ($total_swap,$reserved_pages,$available_pages);
my $lookup_str="Transaction Rate:";
while ( $out =~ s/(TMFCOM_STATUS_TMF_START::.*)$lookup_str(.*)(::TMFCOM_STATUS_TMF_END)/$1$3/s ){

   my $buf=$2;
#   if ( $buf =~ /(.*?)([0-9]+\.[0-9]+)\s*TPS/s ){
   if ( $buf =~ /(.*?)(\d+)\s*TPS/s ){
	   my $t=$1; #This is TPS
	   print "t value = ".$t."\n";
	   $t = sprintf("%f",$t) ; # Don't round off.
	   $perf_data.="TPS= ".$t;
	   $main_data.="Transaction Rate = ".$t." TPS";
   }

=head not required
   if ($buf =~ /Total\s*swap\s*space\s*(\d+\.\d+)/ ) {
			   $perf_data.=" CPU${cpu_number}_total_swap_space=".$1."GB";
			   $main_data.=", SWAP${cpu_number} Total = ".$1."GB";
			   $total_swap=$1;
   }
=cut

#   if ($buf =~ /Transaction\s*Rate:\s*(\d+)/ ) {
#                           my $t=$1; #This is TPS
#                           $t = sprintf("%.3f",$t) ; #This will convert to GB
#			   $perf_data.="TPS=".$t;
#			   $main_data.="Transaction Rate = ".$t."TPS";
#   }
}
$perf_data =~ s/^,//;
$perf_data =~ s/^\s+//;
$main_data =~ s/^, //;

print "$status - " . $main_data . "" . " |$perf_data" . "\n";

exit $ret_code;

