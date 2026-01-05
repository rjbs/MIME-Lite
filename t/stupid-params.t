#!/usr/bin/perl
use strict;
use warnings;

use MIME::Lite;
use Test::More tests => 1;

my @stupid_params = (
  foo => 'bar',
  baz => [ qw(a b c d) ],
  [ qw(1 2 3 4) ],
  dog => 'cat',
  pig => { wookie => 2, snoozer => 2 },
  { x => 'y' },
);

my %p = MIME::Lite->_unfold_stupid_params(@stupid_params);

my $expected = {
  foo => 'bar',
  baz => [ qw(a b c d) ],

  1 => 2,
  3 => 4,

  dog => 'cat',
  pig => { wookie => 2, snoozer => 2 },

  x => 'y',
};

is_deeply(\%p, $expected, "we can rewrite stupid params");
