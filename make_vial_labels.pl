#!/usr/bin/perl

use warnings;
use strict;

use POSIX qw(strftime);

use utf8;
use open qw(:std :utf8);

use Data::Printer;

my @header;
while (<>) {
    chomp;
    my @row = split /\t/;
    if (not @header) {
        @header = (@row);
        next;
    }
    my %row;
    @row{@header} = @row;
    p %row;
    my $escaped_vial = $row{'IDs'};
    $escaped_vial =~ s/_/\\_/g;
    $escaped_vial =~ s/\s+/\\\\/g;
    my $t_num_only = $row{'IDs'};
    $t_num_only =~ s/\s.+//g;
    # make barcode
    system('iec16022','-f','EPS','-o', 'barcodes/'.$t_num_only.'.eps','-c',$t_num_only);

    print <<EOF;
\\makebox[\\textwidth][s]\{\\parbox\{0.35\\textwidth}{\\includegraphics\[height=10mm,width=10mm,keepaspectratio\]\{barcodes/${t_num_only}.eps\}}%
\\parbox\{0.65\\textwidth\}\{$escaped_vial \\\\ $row{'Name'} \{\\fontsize{1.5mm}{1.5mm}\\selectfont Lemur\}\}%
\}

EOF

}
