use LWP;
use XML::Simple;
use URI::Escape;
use POSIX qw(strftime);

require 'event_length.pl';


# Create a user agent object
#  use LWP::UserAgent;
    my $ua = LWP::UserAgent->new;

	#Create the xml parser
	my $xml = new XML::Simple;

#	my @dates = ("20121109","20121108","20121107");
	my @dates = (20121201 .. 20121205);
	
	foreach my $date(@dates) {
	
		#Get the teams for this user
		my $req = HTTP::Request->new(GET => "http://streak.espn.go.com/mobile/viewMatchups?dateToShow=$date");
		my $res = $ua->request($req);
	
		if ($res->is_success) {
			my $data = $xml->XMLin($res->content, ForceArray => [ 'Matchup' ]);
			my $matchups = $data->{Matchups};
			foreach my $matchup (@{$matchups->{Matchup}}) {
				my $matchupId = $matchup->{MatchupId};
				my $description = $matchup->{Title};
				my $sport = $matchup->{Opponent}->[0]->{Sport};
				my $length = event_length( $sport, $description );
				print "$length $sport -- $description\n";
			}
		}
	}

  
