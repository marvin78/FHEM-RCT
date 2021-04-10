# $Id: 98_RCT.pm  $

package main;

use strict;
use warnings;
use Blocking;

my $version = "0.1.4";

my %gets = (
  "version:noArg"     => "",
); 

my $values = '{
    "values":[ 
    {
      "name": "battery.soc",
      "reading": "battery_soc",
      "unit": "%",
      "factor": 100,
      "intervalFactor": 1
    },
    {
      "name": "battery.soh",
      "reading": "battery_soh",
      "unit": "%",
      "factor": 100,
      "intervalFactor": 10
    },
    {
      "name": "battery.soc_target",
      "reading": "battery_soc_target",
      "unit": "%",
      "factor": 100,
      "intervalFactor": 5
    },
    {
      "name": "battery.soc_target_low",
      "reading": "battery_soc_target_low",
      "unit": "%",
      "factor": 100,
      "intervalFactor": 5
    },
    {
      "name": "battery.temperature",
      "reading": "battery_temperature",
      "unit": "?C",
      "factor": 1,
      "intervalFactor": 5
    },
    {
      "name": "battery.efficiency",
      "reading": "battery_efficiency",
      "unit": "",
      "factor": 1,
      "intervalFactor": 10
    },
    {
      "name": "battery.used_energy",
      "reading": "battery_used_energy",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 10
    },
    {
      "name": "g_sync.p_ac_sum",
      "reading": "power_real",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "g_sync.p_acc_lp",
      "reading": "power_battery",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "g_sync.p_ac_grid_sum_lp",
      "reading": "power_grid_total",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "g_sync.p_ac_sum_lp",
      "reading": "power_ac",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "g_sync.q_ac_sum_lp",
      "reading": "power_reactive",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "g_sync.p_ac[0]",
      "reading": "power_ac1",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "g_sync.p_ac[1]",
      "reading": "power_ac2",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "g_sync.p_ac[2]",
      "reading": "power_ac3",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "dc_conv.dc_conv_struct[0].p_dc_lp",
      "reading": "power_solarA",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "dc_conv.dc_conv_struct[1].p_dc_lp",
      "reading": "power_solarB",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "g_sync.p_ac_load_sum_lp",
      "reading": "power_household_external",
      "unit": "W",
      "factor": 1,
      "intervalFactor": 1
    },
    {
      "name": "energy.e_ac_day",
      "reading": "energy_day",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_grid_feed_day",
      "reading": "energy_day_grid_feed_in",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_load_day",
      "reading": "energy_day_household",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_ext_day_sum",
      "reading": "energy_day_external",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_grid_load_day",
      "reading": "energy_day_grid_load",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_dc_day[0]",
      "reading": "energy_day_solarA",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_dc_day[1]",
      "reading": "energy_day_solarB",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_ac_month",
      "reading": "energy_month",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_grid_feed_month",
      "reading": "energy_month_grid_feed_in",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_load_month",
      "reading": "energy_month_household",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_ext_month_sum",
      "reading": "energy_month_external",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_grid_load_month",
      "reading": "energy_month_grid_load",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_dc_month[0]",
      "reading": "energy_month_solarA",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_dc_month[1]",
      "reading": "energy_month_solarB",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_ac_year",
      "reading": "energy_year",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_grid_feed_year",
      "reading": "energy_year_grid_feed_in",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_load_year",
      "reading": "energy_year_household",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_ext_year_sum",
      "reading": "energy_year_external",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_grid_load_year",
      "reading": "energy_year_grid_load",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_dc_year[0]",
      "reading": "energy_year_solarA",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_dc_year[1]",
      "reading": "energy_year_solarB",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_ac_total",
      "reading": "energy_total",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_grid_feed_total",
      "reading": "energy_total_grid_feed_in",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_load_total",
      "reading": "energy_total_household",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_ext_total_sum",
      "reading": "energy_total_external",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_grid_load_total",
      "reading": "energy_total_grid_load",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_dc_total[0]",
      "reading": "energy_total_solarA",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    },
    {
      "name": "energy.e_dc_total[1]",
      "reading": "energy_total_solarB",
      "unit": "Wh",
      "factor": 1,
      "intervalFactor": 2
    }
  ]
}';

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
                            "values:textField-long ".
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
	  $hash->{helper}{counter}=0;
	  readingsSingleUpdate($hash,"state","active",1);
	  ### RCT start poll here
    RemoveInternalTimer($hash, "RCT::StartGetData");
    RemoveInternalTimer($hash, "RCT::ValuesToAttribute");
    InternalTimer(gettimeofday()+1, "RCT::ValuesToAttribute", $hash, 0);
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

  RemoveInternalTimer($hash, "RCT::ValuesToAttribute");
  InternalTimer(gettimeofday()+1, "RCT::ValuesToAttribute", $hash, 0);

  RemoveInternalTimer($hash, "RCT::StartGetData");
	InternalTimer(gettimeofday()+2, "RCT::StartGetData", $hash, 0);
	
	$hash->{helper}{counter}=0;

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
      Log3 $name, 4, "RCT ($name): set new pollInterval to 1800 (standard)";
    }
    RCT::RestartGetTimer($hash);
  }
  
  if ( $attrName eq "values" ) {
    if ( $cmd eq "set" ) {
      if (!eval{decode_json($attrVal)}) {
        return "$name: values has to be valid JSON";  
      }
      Log3 $name, 4, "RCT ($name): set new values to $attrVal";
    }
    elsif ( $cmd eq "del" ) {
      RemoveInternalTimer($hash, "RCT::ValuesToAttribute");
      InternalTimer(gettimeofday()+3, "RCT::ValuesToAttribute", $hash, 0);
      Log3 $name, 4, "RCT ($name): set new values to standard";
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

# commands to attribute

sub ValuesToAttribute($hash) {
  my ($hash) = @_;
  
  my $name = $hash->{NAME};
  
  my $attrVal="";
  
  if (AttrVal($name,"values","-") eq "-")  {
    CommandAttr( undef, $name . ' values '.$values );
  }
  
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
  
  $hash->{helper}{counter} = 0 if (!defined($hash->{helper}{counter}) || $hash->{helper}{counter}==1000);
  
  $hash->{helper}{counter}++;
              
	
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
	
	$values = AttrVal($name,"values",$values);
	
	my $decoded_json = decode_json($values);
	
	my @vals = @{$decoded_json->{"values"}};

   
	
	foreach my $val (@vals) {
	  
	   my $mod = $hash->{helper}{counter} % $val->{intervalFactor};
	  
	  
	  if ($val->{intervalFactor}!=0 && $mod==0) {

      $temp{$val->{reading}} = qx(rctclient read-value --host $hash->{HOST} --port $hash->{PORT} --name $val->{name});
      
      if ($temp{$val->{reading}} =~ /^-?\d+\.?\d*$/){
      
        $temp{$val->{reading}} =~ s/^\s+|\s+$//g;
        
        $temp{$val->{reading}} = $temp{$val->{reading}}*$val->{factor};
        
        $temp{$val->{reading}} = sprintf('%.2f', $temp{$val->{reading}});
        
      }
    
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
