class CLDR::Number;

constant $CLDR_VERSION = '24';

# XXX: data for testing
my %locales = (
    root => {
        default_number_system     => 'latn',
        other_number_systems      => { native => 'latn' },
        decimal_sign              => '.',
        group_sign                => ',',
        list_sign                 => ';',
        percent_sign              => '%',
        plus_sign                 => '+',
        minus_sign                => '-',
        exponent_sign             => 'E',
        superscript_exponent_sign => '×',
        per_mille_sign            => '‰',
        infinity_sign             => '∞',
        nan_sign                  => 'NaN',
        decimal_pattern           => '#,##0.###',
        scientific_pattern        => '#E0',
        percent_pattern           => '#,##0%',
        currency_pattern          => '¤ #,##0.00',
        at_least_pattern          => '⩾{0}',
        range_pattern             => '{0}–{1}',
    },
    ar => {
        default_number_system => 'arab',
        other_number_systems  => { native => 'arab' },
        decimal_sign          => '٫',
        group_sign            => '٬',
        list_sign             => '؛',
        percent_sign          => '٪',
        plus_sign             => "\c[RIGHT-TO-LEFT MARK]+",
        minus_sign            => "\c[RIGHT-TO-LEFT MARK]-",
        exponent_sign         => 'ﺎﺳ',
        per_mille_sign        => '؉',
        nan_sign              => 'ﻞﻴﺳ ﺮﻘﻣ',
        currency_pattern      => '¤ #,##0.00',
        at_least_pattern      => '+{0}',
    },
    en => {
        currency_pattern   => '¤#,##0.00;(¤#,##0.00)',
        at_least_pattern   => '{0}+',
    },
    fr => {
        decimal_sign       => ',',
        group_sign         => ' ',
        percent_pattern    => '#,##0 %',
        currency_pattern   => '#,##0.00 ¤;(#,##0.00 ¤)',
        at_least_pattern   => 'au moins {0}',
        range_pattern      => 'de {0} à {1}',
    },
    in => {
        decimal_pattern    => '#,##,##0.###',
        percent_pattern    => '#,##,##0%',
        currency_pattern   => '¤ #,##,##0.00',
    },
);

# TODO: patternDigit
my @attributes = <
    default_number_system
    other_number_systems
    decimal_sign
    group_sign
    list_sign
    percent_sign
    plus_sign
    minus_sign
    exponent_sign
    superscript_exponent_sign
    per_mille_sign
    infinity_sign
    nan_sign
    decimal_pattern
    percent_pattern
    scientific_pattern
    currency_pattern
    at_least_pattern
    range_pattern
>;

my @optional_attributes = <
    currency_decimal_sign
    currency_group_sign
>;

has $.default_number_system is rw;
has $.other_number_systems is rw;
has $.decimal_sign is rw;
has $.group_sign is rw;
has $.list_sign is rw;
has $.percent_sign is rw;
has $.plus_sign is rw;
has $.minus_sign is rw;
has $.exponent_sign is rw;
has $.superscript_exponent_sign is rw;
has $.per_mille_sign is rw;
has $.infinity_sign is rw;
has $.nan_sign is rw;
has $.decimal_pattern is rw;
has $.percent_pattern is rw;
has $.scientific_pattern is rw;
has $.currency_pattern is rw;
has $.at_least_pattern is rw;
has $.range_pattern is rw;
has $.currency_decimal_sign is rw;
has $.currency_group_sign is rw;
has $.attribute is rw;

has $.cldr_version = $CLDR_VERSION;

# TODO: validate
has $.locale is rw = 'en';

has $.currency_code is rw;

submethod BUILD (:$.locale, *%) {
    for @attributes, @optional_attributes -> $attribute {
        next if self.$attribute.defined;
        self.$attribute = %locales{$.locale}{$attribute}
                       // %locales{root}{$attribute};
    }
}

submethod locale ($.locale) {
    for @attributes, @optional_attributes -> $attribute {
        self.$attribute = %locales{$.locale}{$attribute}
                       // %locales<root>{$attribute};
    }
}

method decimal (Num $num) {
    my $negative = $num < 0;

    return $num;
};

method short_decimal (Num $num) {
    #my $res = $.short_decimal_pattern;

    return $num;
};

method long_decimal (Num $num) {
    #my $res = $.long_decimal_pattern;

    return $num;
};

method percent (Num $num) {
    my $res = $.percent_pattern;

    return $num * 100;
};

method per_mille {
    my $res = $.percent_pattern;

    return $num * 1000;
};

method scientific (Num $num) {
    my $res = $.scientific_pattern;

    return $num;
};

method currency (Num $num) {
    my $res = $.currency_pattern;

    return $num;
};

method at_least (Num $num) {
    return $.at_least_pattern.subst(
        '{0}' => $.decimal($num)
    );
};

method range (Num $num0, $num1) {
    return $.range_pattern.subst(
        '{0}' => $.decimal($num0),
        '{1}' => $.decimal($num1),
    );
};

1;

=encoding UTF-8

=head1 NAME

CLDR::Number - Unicode CLDR formatter for numbers

=head1 SYNOPSIS

    use CLDR::Number;

    CLDR::Number.locales          # list
    CLDR::Number.is_locale('es')  # true
    CLDR::Number.is_locale('xx')  # false

    CLDR::Number.currencies          # list
    CLDR::Number.is_currency('EUR')  # true
    CLDR::Number.is_currency('XXX')  # false

    $numf = CLDR::Number.new(
        locale        => 'es',
        currency_code => 'USD',
    );

    $numf.decimal(1337)   # 1.337
    $numf.decimal(-1337)  # -1.337
    $numf.percent(1337)   # 1.337%
    $numf.currency(1337)  # 1.337,00 $

    $numf.precision = 3;
    $numf.currency_code = 'EUR';
    $numf.decimal(1337)   # 1.337,000
    $numf.percent(1337)   # 1.337,000%
    $numf.currency(1337)  # 1.337,00 €

    $numf.locale = 'en';
    $numf.short_decimal(2337)     # 2K
    $numf.short_decimal(1337123)  # 1M
    $numf.long_decimal(2337)      # 2 thousand
    $numf.long_decimal(1337123)   # 1 million

=head1 METHODS

=over

=item decimal

=item short_decimal

=item long_decimal

=item scientific

=item percent

=item per_mille

=item currency

=item at_least

=item range

=back

=head1 NOTES

    otherNumberingSystems (native, traditional, finance)
    accountingCurrencyPattern

=over

=item * only the Latin (C<latn>) number system currently is supported

=item * only the C<standard> type of formats are currently supported, not C<short>, C<long>, etc.

=back

=head1 SEE ALSO

=over

=item * L<UTS #35: Unicode LDML, Part 3: Numbers|http://www.unicode.org/reports/tr35/tr35-numbers.html>

=item * L<Perl CLDR|http://perl-cldr.github.io/>

=back

=head1 AUTHOR

Nick Patch <patch@cpan.org>

=head1 COPYRIGHT AND LICENSE

© 2013 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
