use warnings;
use strict;

my $PRJDIR=$ARGV[0];
my $CURDIR=`pwd`;
my $TARGETDIR;
my $BD_TYPE=$ENV{'SSDK_BOARD_TYPE'};

if (defined($PRJDIR)) {
	  print "PROJECT ROOT PATH:$PRJDIR \n";
	  $TARGETDIR="$PRJDIR/board/ssdk_header/include";
} else {
    chop $CURDIR;
    $PRJDIR="$CURDIR/..";
    print "Not define PROJECT ROOT PATH, set $PRJDIR as ROOT PATH it's get from CURRENT PATH! \n";
    $TARGETDIR="$CURDIR/ssdk_header/include";
}

#config2h.pl - compile config into header file
open CFGFILE, "$PRJDIR/config$BD_TYPE";
open HEADERFILE, ">$PRJDIR/board/build_mode.h";


printf HEADERFILE "#ifndef _BUILD_MODE_H_\n";
printf HEADERFILE "#define _BUILD_MODE_H_\n\n";

print HEADERFILE <<'EOT';
/*****************************************************
  This file is automatically generated by config2h.pl.
  Except macro MODULE_TYPE_KSLIB and MODULE_TYPE_USLIB
  Please DO NOT EDIT other items!

  when build kernel space parts you can define
  #define MODULE_TYPE_KSLIB
  when build user space parts you can define
  #define MODULE_TYPE_USLIB
******************************************************/

#define MODULE_TYPE_KSLIB
//#define MODULE_TYPE_USLIB




#ifdef MODULE_TYPE_KSLIB
    #define KERNEL_MODULE
#endif

EOT

my $osver_cfg = 0;
my $kmode_cfg = 0;
my $fal_cfg = 0;
my $chiptype_cfg = 0;
my $athena=0;
my $garuda=0;
my $shiva=0;
my $horus=0;
my $isis=0;
my $isisc=0;
my ($attr,$val) = (undef, undef);

while (<CFGFILE>) { 

	chomp; 
	s/^\s+//;   # del space at end
	s/\s+$//;   #  del space at start
	
	next if(!/=/); #skip not '='
	next if(/#/);  #skip '#' at start
	
	if(/^(.*)=(.*)$/){
		$attr = $1;
		$val = $2;
	}

	next if ($attr eq "CPU");
	next if ($attr eq "OS");
	next if ($attr eq "TOOL_PATH");
	next if ($attr eq "SYS_PATH");
	next if ($attr eq "CPU_CFLAG");

	if ($attr eq "OS_VER") {
		$osver_cfg = 1;
		if ($val eq "2_4") {
		  printf HEADERFILE "#define KVER24\n";
		} else {
		  printf HEADERFILE "#define KVER26\n";
		}

	} elsif ($attr eq "KERNEL_MODE") {
	    $kmode_cfg = 1;
	    if ($val eq "TRUE") {
	    	 printf HEADERFILE "#define KERNEL_MODE\n";
	    } else {
	       printf HEADERFILE "#define USER_MODE\n";
	    }
	    
	} elsif ($attr eq "FAL") {
	    $fal_cfg = 1;
	    if ($val eq "TRUE") {
	    } else {
	        printf HEADERFILE "#define HSL_STANDALONG\n";
	    }
	    
  	} elsif ($attr eq "CHIP_TYPE") {
		$chiptype_cfg = 1;
		if ($val eq "ATHENA") {
			  $athena = 1;
			  printf HEADERFILE "#define ATHENA\n";
		} elsif ($val eq "SHIVA") {
		  $shiva = 1;
		  printf HEADERFILE "#define SHIVA\n";
		} elsif ($val eq "HORUS") {
		  $horus = 1;
		  printf HEADERFILE "#define HORUS\n";
		} elsif ($val eq "GARUDA") {
		  $garuda = 1;
		  printf HEADERFILE "#define GARUDA\n";
		} elsif ($val eq "ISIS") {
		  $isis = 1;
		  printf HEADERFILE "#define ISIS\n";
		} elsif ($val eq "ISISC") {
		  $isisc = 1;
		  printf HEADERFILE "#define ISISC\n";
		} elsif ($val eq "ALL_CHIP") {
		  $garuda = 1;
		  printf HEADERFILE "#define GARUDA\n";
		  $shiva = 1;
		  printf HEADERFILE "#define SHIVA\n";
		  $horus = 1;
		  printf HEADERFILE "#define HORUS\n";
		  $isis = 1;
		  printf HEADERFILE "#define ISIS\n";
		  $isisc = 1;
		  printf HEADERFILE "#define ISISC\n";
		} 
	   
  	} else {
		if ($val eq "TRUE") {
		    printf HEADERFILE "#define $attr\n";
		}
    }

    if ($attr eq "UK_NL_PROT") {
        printf HEADERFILE "#define $attr $val\n";
    }

    if ($attr eq "UK_MINOR_DEV") {
        printf HEADERFILE "#define $attr $val\n";
    }
}

if ($osver_cfg eq 0) {
    printf HEADERFILE "#define KVER26\n";
}

if ($kmode_cfg eq 0) {
    printf HEADERFILE "#define KERNEL_MODE\n";
}

if ($fal_cfg eq 0) {
    printf HEADERFILE "#define HSL_STANDALONG\n";
}

if ($chiptype_cfg eq 0) {
	  $garuda = 1;
    printf HEADERFILE "#define GARUDA\n";
}

printf HEADERFILE "\n";
printf HEADERFILE "#endif\n";

close CFGFILE;
close HEADERFILE;

system("cp -f $PRJDIR/board/build_mode.h $PRJDIR/include/common/build_mode.h");




#If you need't copy header files to board directory you can comment below statements
#=del
system("rm -rf $PRJDIR/board/ssdk_header");
system("mkdir  $PRJDIR/board/ssdk_header");
system("mkdir  $TARGETDIR");

system("cp -f $PRJDIR/board/build_mode.h $TARGETDIR/");
system("rm -f $PRJDIR/board/build_mode.h");

system("cp -R $PRJDIR/include/common/ $TARGETDIR/common/");
system("cp -R $PRJDIR/include/fal/ $TARGETDIR/fal");
system("rm -f $TARGETDIR/fal/fal_api.h");

system("mkdir $TARGETDIR/hsl");
if ($athena eq 1) {
	  system("cp -R $PRJDIR/include/hsl/athena/ $TARGETDIR/hsl/athena/");
    system("rm -f $TARGETDIR/hsl/athena/athena_api.h");
}

if ($garuda eq 1) {
  	system("cp -R $PRJDIR/include/hsl/garuda/ $TARGETDIR/hsl/garuda/");
    system("rm -f $TARGETDIR/hsl/garuda/garuda_api.h");
}

if ($shiva eq 1) {
    system("cp -R $PRJDIR/include/hsl/shiva/ $TARGETDIR/hsl/shiva/");
    system("rm -f $TARGETDIR/hsl/shiva/shiva_api.h");
}

if ($horus eq 1) {
    system("cp -R $PRJDIR/include/hsl/horus/ $TARGETDIR/hsl/horus/");
    system("rm -f $TARGETDIR/hsl/horus/horus_api.h");
}

if ($isis eq 1) {
    system("cp -R $PRJDIR/include/hsl/isis/ $TARGETDIR/hsl/isis/");
    system("rm -f $TARGETDIR/hsl/isis/isis_api.h");
}

if ($isisc eq 1) {
    system("cp -R $PRJDIR/include/hsl/isisc/ $TARGETDIR/hsl/isisc/");
    system("rm -f $TARGETDIR/hsl/isisc/isisc_api.h");
}

system("cp $PRJDIR/include/hsl/hsl.h $TARGETDIR/hsl/");
system("cp -R $PRJDIR/include/init/ $TARGETDIR/init/");
system("cp -R $PRJDIR/include/sal/ $TARGETDIR/sal/");
#=cut