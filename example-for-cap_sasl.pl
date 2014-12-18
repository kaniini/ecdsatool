# This is an `ecdsatool` usage example that could be inserted into Irssi's
# cap_sasl.pl script.
#
# (Don't actually do that, though, since cap_sasl.pl already has its own
# Perl-native implementation of ECDSA-NIST256P-CHALLENGE. Instead, use
# <https://github.com/atheme/atheme/blob/master/contrib/cap_sasl.pl>.)

sub in_path {
	my $exe = shift;
	return grep {-x "$_/$exe"}
	       map {length $_ ? $_ : "."}
	       split(":", $ENV{PATH});
}

if (in_path("ecdsatool")) {
	my $ecdsa_sign = sub {
		if (open(my $proc, "-|", "ecdsatool", "sign", @_)) {
			chomp(my $resp = <$proc>);
			close($proc);
			return $resp;
		}
	};
	$mech{'ECDSA-NIST256P-CHALLENGE'} = sub {
		my($sasl, $data) = @_;
		my $u = $sasl->{user};
		my $k = $sasl->{password};
		if ($k !~ m!^/!) {
			$k = Irssi::get_irssi_dir()."/".$k;
		}
		if (!-f $k) {
			Irssi::print("SASL: key file '$k' not found", MSGLEVEL_CLIENTERROR);
			return;
		}
		my $step = ++$sasl->{step};
		if ($step == 1) {
			if (length $data) {
				my $signpayload = encode_base64($data);
				my $payload = $ecdsa_sign->($k, $signpayload);
				return $u."\0".$u."\0".decode_base64($payload);
			} else {
				return $u."\0".$u;
			}
		}
		elsif ($step == 2) {
			my $signpayload = encode_base64($data);
			my $payload = $ecdsa_sign->($k, $signpayload);
			return decode_base64($payload);
		}
	};
};

# vim: ts=4:sw=4
