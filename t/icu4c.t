use v6;
use Test;
BEGIN { @*INC.push('lib') };
use CLDR::Number;

plan 2;

my $f = CLDR::Number.new;
my ($in, $out);

# Tests from ICU4C:
# source/test/intltest/numfmtst.cpp

# NumberFormatTest::TestPerMill
$f.percent_pattern('###.###%');
is $f.per_mille(0.4857), '485.7‰', '0.4857 x ###.###‰';
$f.percent_sign('m');
is $f.per_mille(0.4857), '485.7m', '0.4857 x ###.###m';
