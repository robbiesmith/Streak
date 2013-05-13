    use strict;
    use warnings;
    
    sub event_length {
    (my $sport, my $description) = @_;

	my $length = 0;
	$sport = lc($sport);
	$description = lc($description);
	
	if ( $sport eq "mlb" || $sport eq "cbase" || $sport eq "soft" ) {
		if (index($description, "inning") != -1) {
			$length = 20;
		} else {
			$length = 180;
		}
	} elsif ( $sport eq "nfl" || $sport eq "ncf" || $sport eq "cfl" || $sport eq "football" ) {
		if (index($description, "half") != -1) {
			$length = 90;
		} elsif (index($description, "quarter") != -1 ) {
			$length = 45;
		} else {
			$length = 180;
		}
	} elsif ( $sport eq "nba" || $sport eq "wnba" || $sport eq "ncb" || $sport eq "ncw" || $sport eq "hoops" ) {
		if (index($description, "half") != -1) {
			$length = 75;
		} elsif (index($description, "quarter") != -1 ) {
			$length = 40;
		} else {
			$length = 150;
		}
	} elsif ( $sport eq "nhl" || $sport eq "hockey" ) {
		if (index($description, "period") != -1) {
			$length = 60;
		} else {
			$length = 150;
		}
	} elsif ( $sport eq "golf" ) {
		if (index($description, "18 holes") != -1) {
			$length = 240;
		} elsif (index($description, "round") != -1 ) {
			$length = 240;
		} elsif (index($description, "hole") != -1 ) {
			$length = 20;
		} elsif (index($description, "par") != -1 ) {
			$length = 20;
		} else {
			$length = 240;
		}
	} elsif ( $sport eq "soccer" ) {
		if (index($description, "half") != -1) {
			$length = 60;
		} else {
			$length = 120;
		}
	} elsif ( $sport eq "tennis" ) {
		if (index($description, "set") != -1) {
			$length = 60;
		} else {
			$length = 120;
		}
	} elsif ( $sport eq "lax" ) {
		$length = 120;
	} elsif ( $sport eq "rugby" ) {
		$length = 120;
	} elsif ( $sport eq "horse" ) {
		$length = 20;
	} elsif ( $sport eq "mma" || $sport eq "boxing" || $sport eq "wrestling" ) {
		$length = 60;
	} elsif ( $sport eq "nascar" ) {
		$length = 180;
	} elsif ( $sport eq "cycling" ) {
		$length = 240;
	} elsif ( $sport eq "track" ) {
		$length = 60;
	} else {
		$length = 180;
		print "UNKNOWN SPORT: $sport -- $description\n";
	}

    return $length;

}

1;
    