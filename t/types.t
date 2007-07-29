#!/usr/bin/perl
use lib "lib", "t";
BEGIN {
    $::SKIP=!eval("require MIME::Types; 1");
}
use MIME::Lite;
use ExtUtils::TBone;
use Utils;

# Make a tester... here are 3 different alternatives:
my $T = typical ExtUtils::TBone;                 # standard log
$MIME::Lite::VANILLA  = 1;
# Begin testing:
$T->begin(1);
if  ($::SKIP) {
  warn "#\n#Interaction with MIME::Types has not been tested\n#as it doesn't seem to be present.\n";
  $T->ok(1,"MIME::Types not available.");
} elsif (eval { MIME::Types->VERSION(1.004) }) {
    warn "#\n#Testing MIME::Types interaction\n";
    my $msg;
    $msg = MIME::Lite->new(
                     From     =>'me@myhost.com',
                     To       =>'you@yourhost.com',
                     Cc       =>'some@other.com, some@more.com',
                     Subject  =>'Helloooooo, nurse!',
                     Data     =>"How's it goin', eh?"
                     );

    $msg->attach(
               Type     => 'AUTO',
               Path     => "./testin/test.html",
               ReadNow  => 1,
               Filename => "test.html");

    (my $ret=$msg->stringify)=~s/^Date:.*\n//m;
    $T->msg("!!!MESSAGE\n".$ret."!!!/MESSAGE\n");

    my $expect=<<'EOFEXPECT';
Content-Transfer-Encoding: 7bit
Content-Type: multipart/mixed; boundary="_----------=_0"
MIME-Version: 1.0
From: me@myhost.com
To: you@yourhost.com
Cc: some@other.com, some@more.com
Subject: Helloooooo, nurse!

This is a multi-part message in MIME format.

--_----------=_0
Content-Disposition: inline
Content-Length: 19
Content-Transfer-Encoding: binary
Content-Type: text/plain

How's it goin', eh?
--_----------=_0
Content-Disposition: inline; filename="test.html"
Content-Transfer-Encoding: 8bit
Content-Type: text/html; name="test.html"

This isn't really html. We are only checking the filename silly.
--_----------=_0--

EOFEXPECT


    $T->msg("!!!EXPECT\n".$expect."!!!/EXPECT\n");

    $T->ok_eq($ret,$expect);

} else {
    warn "#\n#Your version of MIME::Types (".($MIME::Types::VERSION||'undef??').") is too old to use. Please upgrade to the latest.\n";
    $T->ok(1,"Your version of MIME::Types (".($MIME::Types::VERSION||'undef??').") is too old to use. Please upgrade to the latest.");
}
$T->end;
__DATA__
