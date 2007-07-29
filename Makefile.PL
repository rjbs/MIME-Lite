#!/usr/bin/perl
use ExtUtils::MakeMaker;

#------------------------------------------------------------
# Makefile:
#------------------------------------------------------------

print "MIME::Lite is designed to take advantage of a variety of external modules\n",
      "if they are not present then MIME::Lite will attempt to do its best\n",
      "but its strongly recommend that you install them.\n\n",
      "These modules are:\n",
      "\tMail::Address\n",
      "\tMIME::Types\n",
      "\tFile::Basename\n",
      "\tMIME::Base64\n",
      "\tMIME::QuotedPrint\n",
      "Some or all of these maybe included with your perl, neverless if you wish\n",
      "I can add these modules to the prereq list which will cause the files to be\n",
      "automatically installed if they arent already present\n";
my %prereq;
if (prompt("Add prereqs?",'Yes')=~/y/i) {
    %prereq=(
              'Mail::Address'     => 1.62,
              'MIME::Types'       => 1.13,
              'File::Basename'    => undef,
              'MIME::Base64'      => undef,
              'MIME::QuotedPrint' => undef,
            );
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
  'PREREQ_PM'    => \%prereq,
);

