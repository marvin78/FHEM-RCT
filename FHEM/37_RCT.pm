# $Id: 98_RCT.pm  $

package main;

use strict;
use warnings;
use Blocking;

my $version = "0.0.16";

my %gets = (
  "version:noArg"     => "",
); 

# Commands
my %commands;

$commands{"battery_soc"} = "battery.soc";
$commands{"battery_soh"} = "battery.soh";

$commands{"power_real"} = "g_sync.p_ac_sum";
$commands{"power_battery"} = "g_sync.p_acc_lp";
$commands{"power_grid_total"} = "g_sync.p_ac_grid_sum_lp";
$commands{"power_ac"} = "g_sync.p_ac_sum_lp";
$commands{"power_reactive"} = "g_sync.q_ac_sum_lp";
$commands{"power_ac1"} = "g_sync.p_ac[0]";
$commands{"power_ac2"} = "g_sync.p_ac[1]";
$commands{"power_ac3"} = "g_sync.p_ac[2]";
$commands{"power_solarA"} = "dc_conv.dc_conv_struct[0].p_dc_lp";
$commands{"power_solarB"} = "dc_conv.dc_conv_struct[1].p_dc_lp";
$commands{"power_household_external"} = "g_sync.p_ac_load_sum_lp";

$commands{"energy_day"} = "energy.e_ac_day";
$commands{"energy_day_grid_feed_in"} = "energy.e_grid_feed_day";
$commands{"energy_day_household"} = "energy.e_load_day";
$commands{"energy_day_external"} = "energy.e_ext_day_sum";
$commands{"energy_day_grid_load"} = "energy.e_grid_load_day";
$commands{"energy_day_solarA"} = "energy.e_dc_day[0]";
$commands{"energy_day_solarB"} = "energy.e_dc_day[1]";

$commands{"energy_month"} = "energy.e_ac_month";
$commands{"energy_month_grid_feed_in"} = "energy.e_grid_feed_month";
$commands{"energy_month_household"} = "energy.e_load_month";
$commands{"energy_month_external"} = "energy.e_ext_month_sum";
$commands{"energy_month_grid_load"} = "energy.e_grid_load_month";
$commands{"energy_month_solarA"} = "energy.e_dc_month[0]";
$commands{"energy_month_solarB"} = "energy.e_dc_month[1]";

$commands{"energy_year"} = "energy.e_ac_year";
$commands{"energy_year_grid_feed_in"} = "energy.e_grid_feed_year";
$commands{"energy_year_household"} = "energy.e_load_year";
$commands{"energy_year_external"} = "energy.e_ext_year_sum";
$commands{"energy_year_grid_load"} = "energy.e_grid_load_year";
$commands{"energy_year_solarA"} = "energy.e_dc_year[0]";
$commands{"energy_year_solarB"} = "energy.e_dc_year[1]";

$commands{"energy_total"} = "energy.e_ac_total";
$commands{"energy_total_grid_feed_in"} = "energy.e_grid_feed_total";
$commands{"energy_total_household"} = "energy.e_load_total";
$commands{"energy_total_external"} = "energy.e_ext_total_sum";
$commands{"energy_total_grid_load"} = "energy.e_grid_load_total";
$commands{"energy_total_solarA"} = "energy.e_dc_total[0]";
$commands{"energy_total_solarB"} = "energy.e_dc_total[1]";


sub RCT_Initialize($) {
	my ($hash) = @_;

	$hash->{SetFn}        =   "RCT::Set";
	$hash->{GetFn}        =   "RCT::Get";
	$hash->{DefFn}        =   "RCT::Define";
	$hash->{NotifyFn}     =   "RCT::Notify";
	$hash->{UndefFn}      =   "RCT::Undefine";
	$hash->{DeleteFn}     =   "RCT::Delete";
	$hash->{AttrFn}       =   "RCT::Attr";
	
	$hash->{AttrList}     =   "disable:1,0 ".
                            "disabledForIntervals ".
                            "pollInterval ".
                            $readingFnAttributes;
                            
  $hash->{NotifyOrderPrefix} = "14-";    # order number NotifyFn
	
	## renew version in reload
  foreach my $d ( sort keys %{ $modules{RCT}{defptr} } ) {
      my $hash = $modules{RCT}{defptr}{$d};
      $hash->{VERSION} = $version;
  }
	return undef;                       
}





## Package
package RCT;

use GPUtils qw(:all);    # for importing FHEM functions
use Data::Dumper;    #only for Debugging
use Blocking;
use JSON;

my $missingModul = "";

## import FHEM functions
BEGIN {
    GP_Import(
        qw(devspec2array
          readingsSingleUpdate
          readingsBulkUpdate
          readingsBulkUpdateIfChanged
          readingsBeginUpdate
          readingsEndUpdate
          defs
          modules
          Log3
          CommandAttr
          attr
          AnalyzeCommandChain
          AnalyzePerlCommand
          EvalSpecials
          CommandDeleteAttr
          CommandDeleteReading
          CommandSet
          AttrVal
          ReadingsVal
          Value
          IsDisabled
          deviceEvents
          init_done
          addToDevAttrList
          addToAttrList
          delFromDevAttrList
          delFromAttrList
          gettimeofday
          InternalTimer
          RemoveInternalTimer
          computeAlignTime
          ReplaceEventMap
          getKeyValue
          setKeyValue
          getUniqueId
          CallFn
          FW_ME
          FW_dev2image
          FW_makeImage
          FW_directNotify
          BlockingCall
          BlockingInfo
          BlockingStart
          BlockingInformParent
          BlockingKill
          BlockingExit
          BlockingRegisterTelnet
          BC_searchTelnet
          notifyRegexpChanged)
    );
}

sub Define($$) {
  my ( $hash, $def ) = @_;
  my @a = split( "[ \t][ \t]*", $def );

  return "only one RCT instance allowed" if ( devspec2array('TYPE=RCT') > 1 );
  return "too few parameters: define <name> RCT [<host> <port>]" if ( @a < 2 );
  return "Cannot define RCT device. Perl modul ${missingModul}is missing." if ($missingModul);

  my $name = $a[0];

  $hash->{VERSION} = $version;
  $hash->{MID}     = 'da39a3ee5e6dfjkdl348d434b0d3255bfef95601890afd80709'; # 
  $hash->{NOTIFYDEV} = "global" if (ReadingsVal($name,"state","-") ne "on");    # notify devices (NotifyFn)
  
  $hash->{"HOST"} = $a[2] ? $a[2] : "localhost";
  $hash->{"PORT"} = $a[3] ? $a[3] : "8899";
  $hash->{INTERVAL}=AttrVal($name,"pollInterval",undef)?AttrVal($name,"pollInterval",undef):10;

  Log3( $name, 3, "RCT [$name] - defined" );

  $modules{RCT}{defptr}{ $hash->{MID} } = $hash; #MID for internal purposes
  
  delete $hash->{helper}{RUNNING_PID} if(defined($hash->{helper}{RUNNING_PID}));
  
  ## start polling
	if ($init_done && !IsDisabled($name)) {
	  readingsSingleUpdate($hash,"state","active",1);
	  ### RCT start poll here
    RemoveInternalTimer($hash, "RCT::StartGetData");
    InternalTimer(gettimeofday()+2, "RCT::StartGetData", $hash, 0);
	}
  
  return undef;
}

sub Undefine($$) {
  my ($hash, $arg) = @_;
  
  BlockingKill($hash->{helper}{RUNNING_PID}) if(defined($hash->{helper}{RUNNING_PID}));

	
  RemoveInternalTimer($hash);
	
  return undef;
}

sub Delete($$) {
  my ($hash, $arg) = @_;
  
  BlockingKill($hash->{helper}{RUNNING_PID}) if(defined($hash->{helper}{RUNNING_PID}));

	
  RemoveInternalTimer($hash);
	
  return undef;
}

sub Notify ($$) {
	my ($hash,$dev) = @_;

  return if($dev->{NAME} ne "global");
	
  return if(!grep(m/^INITIALIZED|REREADCFG$/, @{$dev->{CHANGED}}));

  RemoveInternalTimer($hash, "RCT::StartGetData");
	InternalTimer(gettimeofday()+2, "RCT::StartGetData", $hash, 0);

  return undef;

}

## some checks if attribute is set or deleted
sub Attr($@) {
  my ($cmd, $name, $attrName, $attrVal) = @_;
  
  my $orig = $attrVal;
  
  my $hash = $defs{$name};
  
  if ( $attrName eq "disable" ) {

    if ( $cmd eq "set" && $attrVal == 1 ) {
      if ($hash->{READINGS}{state}{VAL} ne "disabled") {
        readingsSingleUpdate($hash,"state","disabled",1);
        RemoveInternalTimer($hash);
        BlockingKill($hash->{helper}{RUNNING_PID}) if(defined($hash->{helper}{RUNNING_PID}));
        Log3 $name, 4, "RCT ($name): $name is now disabled";
      }
    }
    elsif ( $cmd eq "del" || $attrVal == 0 ) {
      if ($hash->{READINGS}{state}{VAL} ne "active") {
        readingsSingleUpdate($hash,"state","active",1);
        RemoveInternalTimer($hash);
        Log3 $name, 4, "RCT ($name): $name is now ensabled";
        RCT::RestartGetTimer($hash);
      }
    }
  }
  
  if ( $attrName eq "pollInterval") {
    if ( $cmd eq "set" ) {
      return "$name: pollInterval has to be a number (seconds)" if ($attrVal!~ /\d+/);
      return "$name: pollInterval has to be greater than or equal 5" if ($attrVal < 5);
      $hash->{INTERVAL}=$attrVal;
      Log3 $name, 4, "RCT ($name): set new pollInterval to $attrVal";
    }
    elsif ( $cmd eq "del" ) {
      $hash->{INTERVAL}=10;
      Log3 $name, 4, "RCTt ($name): set new pollInterval to 1800 (standard)";
    }
    RCT::RestartGetTimer($hash);
  }
  
  
  return;
}

sub Set ($@) {
  my ($hash, $name, $cmd, @args) = @_;
	my @sets = ();
	
	push @sets, "active:noArg" if (IsDisabled($name));
	push @sets, "inactive:noArg" if (!IsDisabled($name));
	
	return join(" ", @sets) if ($cmd eq "?");
	
	my $usage = "Unknown argument ".$cmd.", choose one of ".join(" ", @sets) if(scalar @sets > 0);
	
	if (IsDisabled($name) && $cmd !~ /^(active|inactive)?$/) {
		Log3 $name, 3, "RCT ($name): Device is disabled at set Device $cmd";
		return "Device is disabled. Enable it on order to use command ".$cmd;
	}
	if ( $cmd eq "inactive" ) {
    readingsSingleUpdate($hash,"state","inactive",1);
		RemoveInternalTimer($hash, "RCT::StartGetData");
    BlockingKill($hash->{helper}{RUNNING_PID}) if(defined($hash->{helper}{RUNNING_PID}));
	}
	elsif ( $cmd eq "active") {
    readingsSingleUpdate($hash,"state","active",1);
    RCT::RestartGetTimer($hash);
	}
	else {
		return $usage;
	}

	return undef;
}

sub Get($@) {
  my ($hash, $name, $cmd, @args) = @_;
  my $ret = undef;
  
  if ( $cmd eq "version") {
  	$hash->{VERSION} = $version;
    return "Version: ".$version;
  }
  else {
    $ret ="$name get with unknown argument $cmd, choose one of " . join(" ", sort keys %gets);
  }
 
  return $ret;
}

# restart timers if active
sub RestartGetTimer($) {
  my ($hash) = @_;
  
  my $name = $hash->{NAME};
  
  RemoveInternalTimer($hash, "RCT::StartGetData");
  InternalTimer(gettimeofday()+2, "RCT::StartGetData", $hash, 0) if (!IsDisabled($name));
  
  return undef;
}


sub StartGetData ($) {
	my ($hash) = @_;
	my $name = $hash->{NAME};
  my $seconds = $hash->{"INTERVAL"};
              
	
	unless(exists($hash->{helper}{RUNNING_PID})) {
	
		$hash->{helper}{RUNNING_PID} = BlockingCall("RCT::DoGetData", $name, "RCT::ProcessGetData", 60, "RCT::ProcessAbortedGetData", $hash);
		
		 if(!$hash->{helper}{RUNNING_PID}) {
      delete($hash->{helper}{RUNNING_PID});
             
              
      Log3 $hash->{NAME}, 4, "RCT ($name) - fork failed, rescheduling next check in $seconds seconds";
              
      RemoveInternalTimer($hash, "RCT::StartGetData");
      InternalTimer(gettimeofday()+$seconds, "RCT::StartGetData", $hash, 0) if (!IsDisabled($name));
    }
        
    return undef;
	}		
	else {
		Log3 $hash->{NAME}, 4, "RCT ($name) - another check is currently running. skipping check";
       
        
      Log3 $hash->{NAME}, 4, "RCT ($name) - rescheduling next check in $seconds seconds";
        
      RemoveInternalTimer($hash, "RCT::StartGetData");
      InternalTimer(gettimeofday()+$seconds, "RCT::StartGetData", $hash, 0) if (!IsDisabled($name));
        
      return "another check is currently running";
    }
}

sub DoGetData ($) {
	my ($string) = @_;
	#my ($name, $device) = split("\\|", $string);
  
  my $name = $string;
	
	my $hash = $defs{$name};
  
  Log3 $name, 4, "RCT ($name) - Start DoGetData";
	
	my $retcode;
  my $return;
  my %temp;

  
  my $command = "rctclient read-value --host $hash->{HOST} --port $hash->{PORT} --name battery.soc";
	
	Log3 $name, 4, "RCT ($name) - DoGetData with host ".$hash->{HOST}." and port ".$hash->{PORT};
	Log3 $name, 5, "RCT ($name) - $command";
  
	foreach my $key (keys %commands) {

    $temp{$key} = qx(rctclient read-value --host $hash->{HOST} --port $hash->{PORT} --name $commands{$key});
    
    if ($temp{$key} =~ /^-?\d+\.?\d*$/){
    
      $temp{$key} =~ s/^\s+|\s+$//g;
      
      $temp{$key} = $temp{$key}*100 if ($key =~ /battery_so(|h)/);
      
      $temp{$key} = sprintf('%.2f', $temp{$key});
      
    }
    

  }
  
  
  $return = encode_json(\%temp);

	
	Log3 $name, 5, "RCT ($name) - DoGetData: ".$return;
  
	return $name."|".$return;
	
}

sub ProcessGetData ($) {
	my ($string) = @_;
	
	my @a = split("\\|",$string);
  
  my $hash = $defs{$a[0]}; 
	
  my $name = $hash->{NAME};
  
  Log3 $name, 4, "RCT ($name) - Start ProcessGetData";
		
	delete($hash->{helper}{RUNNING_PID});
  
  my $decoded_json = decode_json($a[1]);
  
  readingsBeginUpdate($hash);
  
  for my $key (keys(%$decoded_json)) {
    if ($decoded_json->{$key} =~ /^-?\d+\.?\d*$/){
	
		
      #readingsSingleUpdate($hash, $key, $decoded_json->{$key}, 1);
      readingsBulkUpdate($hash, $key, $decoded_json->{$key});
  
    }
  }
  
  readingsEndUpdate( $hash, 1 );
  
	my $seconds=$hash->{"INTERVAL"};
	
	Log3 $hash->{NAME}, 4, "RCT ($name) - ProcessGetData";
	
	RemoveInternalTimer($hash, "RCT::StartGetData");
  InternalTimer(gettimeofday()+$seconds, "RCT::StartGetData", $hash, 0) if (!IsDisabled($name));
}

sub ProcessAbortedGetData ($) {
	my ($hash) = @_;
  my $name = $hash->{NAME};
	
	delete($hash->{helper}{RUNNING_PID});
  RemoveInternalTimer($hash);
	
	
	if(defined($hash->{helper}{RETRY_COUNT})) {
    if($hash->{helper}{RETRY_COUNT} >= 3) {
      Log3 $hash->{NAME}, 2, "RCT ($name) - device could not be checked after ".$hash->{helper}{RETRY_COUNT}." ".($hash->{helper}{RETRY_COUNT} > 1 ? "retries" : "retry"). " (resuming normal operation)" if($hash->{helper}{RETRY_COUNT} == 3);
      
			RemoveInternalTimer($hash, "RCT::StartGetData");
			InternalTimer(gettimeofday()+10, "RCT::StartGetData", $hash, 0) if (!IsDisabled($name));
      $hash->{helper}{RETRY_COUNT}++;
    }
    else {
      Log3 $hash->{NAME}, 2, "RCT ($name) - device could not be checked after ".$hash->{helper}{RETRY_COUNT}." ".($hash->{helper}{RETRY_COUNT} > 1 ? "retries" : "retry")." (retrying in 10 seconds)";
       
			 RemoveInternalTimer($hash, "RCT::StartGetData");
			 InternalTimer(gettimeofday()+10, "RCT::StartGetData", $hash, 0) if (!IsDisabled($name));
       $hash->{helper}{RETRY_COUNT}++;
    }

  }
  else {
    $hash->{helper}{RETRY_COUNT} = 1;
		
		RemoveInternalTimer($hash, "RCT::StartGetData");
    InternalTimer(gettimeofday()+10, "RCT::StartGetData", $hash, 0) if (!IsDisabled($name));
    Log3 $name,2, "RCT ($name) - device could not be checked (retrying in 10 seconds)";
  }
}



1;

=pod
=begin html

<a name="RCT"></a>
<h3>RCT</h3>
<ul>
  

</ul>

=end html
=cut

