#!/usr/bin/perl
use ExtUtils::MakeMaker;
#use strict;
#use warnings;

#------------------------------------------------------------
# Makefile:
#------------------------------------------------------------
my %prereq = (
  'File::Spec'          => 0,
  'File::Basename'      => 0,
  'Email::Date::Format' => '1.000', # first release
);
my %optional = (
              'Mail::Address'     => 1.62,
              'MIME::Types'       => 1.28,
              'MIME::Base64'      => 0,
              'MIME::QuotedPrint' => 0,
);

my $str = '';
foreach my $name (keys %optional) {
	eval "use $name";
	if ($@) {
		$str .= "\t$name  $optional{$name}\n";
	} elsif ($name->VERSION < $optional{$name}) {
		my $version = $name->VERSION;
		$str .= "\t$name  $optional{$name} (we found $version)\n";
	}
}

if ($str) {
	print "MIME::Lite is designed to take advantage of a variety of external modules\n",
	      "if they are not present then MIME::Lite will attempt to do its best\n",
	      "but its strongly recommend that you install them.\n\n",
	      "These modules are:\n",
	      $str,
	      "Some or all of these maybe included with your perl, neverless if you wish\n",
	      "I can add these modules to the prereq list which will cause the files to be\n",
	      "automatically installed if they arent already present\n";
	if (prompt("Add prereqs?",'Yes')=~/y/i) {
	    %prereq=( %prereq,
					%optional,
	            );
	}
}

# Write the Makefile:
WriteMakefile(
  NAME         => 'MIME::Lite',
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  VERSION_FROM => "lib/MIME/Lite.pm",
  DISTNAME     => "MIME-Lite",
  EXE_FILES    => [@EXES],
  'dist'       => {
    #PREOP    => 'cvu_perl_preop -m MIME::Lite -f',#demerphq
    COMPRESS => 'gzip',
    SUFFIX   => 'gz',
  },
  (eval { ExtUtils::MakeMaker->VERSION(6.46) }
    ? (META_MERGE => {
        resources => {
          Repository => 'http://github.com/rjbs/mime-lite'
        }
      })
    : ()
  ),
  'PREREQ_PM'    => \%prereq,
);

