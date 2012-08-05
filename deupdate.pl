#!/usr/bin/perl 
#
################################################################
# Filename: deupdate.pl
#
# Description: This script performs single and bulk DE-manager  
#  updates using the cdets findcr and fixcr commands. Also 
#  checks to be sure new DE-mgr is added to project users.
#
# Usage: deupdate, deupdate -b (for bulk),
#        deupdate -b -f <filename>
#
# Author: jadew
#
# Current Maintainer: jadew
#
# Reviewer(s): ?
#
#################################################################

use Pod::Usage;
use Getopt::Long;

GetOptions(
	"--b|bulk" => \$bulk,
	"--f|file=s" => \$filename,
	"--m|man" => \$verbose2,
	"--h|help" => \$verbose1
) or pod2usage( {'VERBOSE' => 0} );

pod2usage( {'VERBOSE' => 1} ) if ( defined( $verbose1 ) );
pod2usage( {'VERBOSE' => 2} ) if ( defined( $verbose2 ) );


__END__

=pod

=head1 NAME

deupdate.pl - DE-manager update for CARETS generated cases

=head1 SYNOPSIS

deupdate.pl [-b [-f <filename>]]

deupdate.pl { --help | --man }

=head1 OPTIONS

=over 8

=item B<-b,--bulk>

Perform a bulk update

=item B<-f,--file=FILENAME>

Specify the file containing the product/component list. If -b is given but not the file, you will be prompted to enter one.

=head1 DESCRIPTION

Perform a DE-manager update in CDETS. To be used with cases ganerated from CARETS.

=cut
