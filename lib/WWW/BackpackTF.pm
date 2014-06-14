package WWW::BackpackTF;

use 5.014000;
use strict;
use warnings;
use parent qw/Exporter/;
our $VERSION = '0.000_001';
our @EXPORT_OK = qw/TF2 DOTA2/;

use constant TF2 => 440;
use constant DOTA2 => 570;

use JSON qw/decode_json/;
use LWP::Simple qw/get/;
use WWW::BackpackTF::User;

sub new{
	my ($class, $key) = @_;
	bless {key => $key}, $class
}

sub get_users{
	my ($self, @users) = @_;
	my $response = decode_json get "http://backpack.tf/api/IGetUsers/v3/?compress=1&format=json&steamids=" . join ',', @users;
	$response = $response->{response};
	die $response->{message} unless $response->{success};
	@users = map { WWW::BackpackTF::User->new($_) } values $response->{players};
	wantarray ? @users : $users[0]
}

1;
__END__

=head1 NAME

WWW::BackpackTF - interface to the backpack.tf trading service

=head1 SYNOPSIS

  use WWW::BackpackTF;
  my $api_key = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
  my $user_id = <STDIN>;
  my $bp = WWW::BackpackTF->new($api_key);
  my $user = $bp->get_users($user_id);
  print 'This user is named ', $user->name, ' and has ', $user->notifications, ' unread notification(s)';

=head1 DESCRIPTION

WWW::BackpackTF is an interface to the backpack.tf Team Fortress 2/Dota 2 trading service.

The only call implemented so far is I<IGetUsers>.

=head2 METHODS

=over

=item B<new>(I<[$api_key]>)

Create a new WWW::BackpackTF object. Takes a single optional parameter, the API key.

=item B<get_users>(I<@users>)

Get profile information for a list of users. Takes any number of 64-bit Steam IDs as arguments and returns a list of WWW::BackpackTF::User objects. This method does not require an API key.

=back

=head2 EXPORTS

None by default.

=over

=item B<TF2>

Constant (440) representing Team Fortress 2.

=item B<DOTA2>

Constant (570) representing Dota 2.

=back

=head1 SEE ALSO

L<http://backpack.tf/>, L<http://backpack.tf/api>

=head1 AUTHOR

Marius Gavrilescu, E<lt>marius@ieval.roE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Marius Gavrilescu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
