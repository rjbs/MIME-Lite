#!/usr/bin/perl
use strict;
use warnings;

use MIME::Lite;
use Test::More tests => 2;

my $subject = 'A subject line which is more than 72 character long.';
$subject .= ' It started short, but then we added more words and now it is longer.';
$subject .= ' It is now 187 characters long which is more than twice the length';
is length($subject),  187;

my $msg = MIME::Lite->new(
    From    => 'me',
    To      => 'you',
    Subject => $subject,
);

my $header = $msg->header_as_string;
$header =~ s/Date: .*/Date:/;

my $expected = <<TEXT;
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
MIME-Version: 1.0
X-Mailer: MIME::Lite 3.035 (F2.86; T2.30; A2.22; B3.16_01; Q3.16_01)
Date:
From: me
To: you
Subject: A subject line which is more than 72 character long. It started short,
 but then we added more words and now it is longer. It is now 187
 characters long which is more than twice the length
TEXT

is $header, $expected;

