use LWP;
use XML::Simple;
use URI::Escape;
use POSIX qw(strftime);
use Date::Parse;

require 'event_length.pl';

# Create a user agent object
#  use LWP::UserAgent;
    my $ua = LWP::UserAgent->new;

	#Create the xml parser
	my $xml = new XML::Simple;

	
my $sleep = 1; #first time through run right away

while ( sleep( $sleep ) ) {
	$sleep = 300;

	my $now_string = localtime;

	print "$now_string\n";

	# http://streak.espn.go.com/mobile/viewMatchups?entryId=9
	# http://streak.espn.go.com/mobile/viewMatchups?swid=
	# http://streak.espn.go.com/mobile/viewMatchups?entryId=9&dateToShow=20110529
	# http://streak.espn.go.com/mobile/savePick?src=2&swid=${swid}&opponentId=${opponentId}&matchupId=${matchupId}
	
	
	open PHONEFILE, "phonenumbers.txt" or die $!;
	
	while (my $phoneNumber = <PHONEFILE>) {
	#	my $phoneNumber = "9176966439"; # Rob Android
	#	my $phoneNumber = "9172792970"; # Dave
	#	my $phoneNumber = "3473023696"; # Rob Phone 7
	#	my $phoneNumber = "3474131043"; # Neil
	# 9176960820 # Hickey
	# 8609067679 # Sujal
	# 9176961116 # Welch
	# 8603357142 # Mullen
	#	if ( $ARGV[0] ) {
	#		$phoneNumber = $ARGV[0];
	#	}
	
		# Find the SWID from the phone number
		my $swid;
	
#		my $swidURL = "http://m.espn.go.com/alerts/util/swidbyphone?phoneNumber=1${phoneNumber}";
		my $swidURL = "http://m.espn.go.com/alerts/util/getSWIDbyMDN?mdn=1${phoneNumber}";
		my $swidReq = HTTP::Request->new(GET => $swidURL);
		my $res = $ua->request($swidReq);
	
	  	if ($res->is_success) {
			$swid = $res->content;
		}
		if ( $swid eq "null" ) {
			print "swid is null for $phoneNumber";
			print $swidURL;
		}
	
		# Fine the username from the swid
		my $username;
	
		my $usernameURL = "http://qam.espn.go.com/mobile/users/smithrp/getUsernameBySWID?SWID=${swid}";
		my $usernameReq = HTTP::Request->new(GET => $usernameURL);
		my $res = $ua->request($usernameReq);
	
	  	if ($res->is_success) {
			$username = $res->content;
		}

	    $ua->default_header('Cookie' => "SWID=${swid}");
	
		#Get the teams for this user
		my $req = HTTP::Request->new(GET => "http://streak.espn.go.com/mobile/viewMatchups?swid=${swid}");
		my $res = $ua->request($req);
	
		if ($res->is_success) {
			my $data = $xml->XMLin($res->content, ForceArray => [ 'Matchup' ]);
			my $current = $data->{Entry}->{CurrentSelection};
			if (!$current) {
				my $matchups = $data->{Matchups};
				
				my $bestMatchupId = 0;
				my $bestOpponentId = 0;
				my $bestEndTime = 9999999999;
				FINDMATCH: foreach my $matchup (@{$matchups->{Matchup}}) {
					my $locked = $matchup->{Locked} eq "true";
					if ( !$locked ) {
						my $matchupId = $matchup->{MatchupId};
						my $startTime = $matchup->{DateScheduledStart};
						my $description = $matchup->{Title};
						my $sport = $matchup->{Opponent}->[0]->{Sport};
						my $length = event_length( $sport, $description );
						my $time = str2time($startTime );
						my $endTime = $time + $length * 60;

						my $random_number = int(rand(2));
						my $opponentId = $matchup->{Opponent}->[$random_number]->{OpponentId};

						if ( $endTime < $bestEndTime ) {
							$bestMatchupId = $matchupId;
							$bestOpponentId = $opponentId;
							$bestEndTime = $endTime;
						}
						print "$matchupId $bestMatchupId $time $startTime $endTime foo\n";
					}
				}
				if ( $bestMatchupId ) {

					my $pickURL = "http://streak.espn.go.com/mobile/savePick?src=2&swid=${swid}&opponentId=${bestOpponentId}&matchupId=${bestMatchupId}";
					my $pickReq = HTTP::Request->new(GET => $pickURL);
					my $res = $ua->request($pickReq);
				
				  	if ($res->is_success) {
						my $pick = $xml->XMLin($res->content);
						my $saved = $pick->{PickSaved} eq "true";
				  		print $pickURL;
				  		if ( $saved ) {
					  		print "\nmade pick $matchupId $opponentId\n";
					  	} else {
					  		print "\npick failed $matchupId $opponentId\n";
					  	}
					}
				}
			} else {
		    	print "already have a pick\n";				
			}

		} else {
		      print $res->status_line, "\n";
		}
	}
}

  
