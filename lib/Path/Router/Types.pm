package Path::Router::Types;
use Moose ();
use Moose::Util::TypeConstraints;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

class_type 'Moose::Meta::TypeConstraint';

subtype 'Path::Router::Route::ValidationMap'
    => as 'HashRef[Moose::Meta::TypeConstraint]';

coerce 'Path::Router::Route::ValidationMap'
    => from 'HashRef[Str | RegexpRef | Moose::Meta::TypeConstraint]'
        => via {
            my %orig = %{ +shift };
            foreach my $key (keys %orig) {
                my $val = $orig{$key};
                if (ref $val eq 'Regexp') {
                    $orig{$key} = subtype('Str' => where{ /^$val$/ });
                }
                else {
                    $orig{$key} = find_type_constraint($val) 
                        || Carp::confess "Could not locate type constraint named $val"; 
                }
            }            
            return \%orig;
        };

no Moose; 1;

__END__

=pod

=head1 NAME

Path::Router::Types - A set of types that Path::Router uses

=head1 SYNOPSIS

  use Path::Router::Types;

=head1 DESCRIPTION

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut