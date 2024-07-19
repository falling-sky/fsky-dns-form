#! /usr/bin/perl

use JSON::PP;

use strict;

my %data;

$data{"domain"} = <<'EOF';
;################################################################
;# ZONE: $argv{domain}. 
;# Put this on your real name servers.  Fix the SOA and NS
;# to reflect your environment.
;################################################################

$TTL 300
@	IN SOA $argv{ns}. $argv{hostmaster}. (
  $argv{serial} ; Serial
  86400 ; Refresh
  7200  ; Retry
  604800 ; Expire
  172800) ; Minimum

; Main web site is intentionally IPv4 only, per the FAQ.
		A	$argv{4}
www		A	$argv{4}

; Specific records for tests
ipv4		A	$argv{4}
ipv6		AAAA	$argv{6}
mtu1280		AAAA	$argv{1280}
ds		A	$argv{4}
ds		AAAA	$argv{6}

; DNS recursive resolver testing;
; Delegated to the VM running $argv{domain}; IPv6-only
v6ns		ns	v6ns1
v6ns1		AAAA	$argv{6}

; Convenience names not used in the tests;
; but perhaps friendly for humans
a		A	$argv{4}
aaaa		AAAA	$argv{6}
www4		A	$argv{4}
www6		AAAA	$argv{6}
v4		A	$argv{4}
v6		AAAA	$argv{6}

EOF

$data{"v6ns"} = <<'EOF';
;################################################################
;# ZONE: v6ns.$argv{domain}. 
;# Put this on the VM operating your test-ipv6.com mirror.
;# Do NOT put this on your main DNS server.
;################################################################

$TTL 300
@	IN SOA v6ns1.$argv{domain}. $argv{hostmaster}. (
  $argv{serial} ; Serial
  86400 ; Refresh
  7200  ; Retry
  604800 ; Expire
  172800) ; Minimum

		NS	v6ns1.$argv{domain}.

; Specific records for tests
ipv4		A	$argv{4}
ipv6		AAAA	$argv{6}
ds		A	$argv{4}
ds		AAAA	$argv{6}
a		A	$argv{4}
aaaa		AAAA	$argv{6}
www4		A	$argv{4}
www6		AAAA	$argv{6}
v4		A	$argv{4}
v6		AAAA	$argv{6}

EOF

$data{"v6ns1"} = <<'EOF';
;################################################################
;# ZONE: v6ns1.$argv{domain}.
;# Put this on the VM operating your test-ipv6.com mirror.
;# Do NOT put this on your main DNS server.
;################################################################

$TTL 300
@	IN SOA v6ns1.$argv{domain}. $argv{hostmaster}. (
  $argv{serial} ; Serial
  86400 ; Refresh
  7200  ; Retry
  604800 ; Expire
  172800) ; Minimum

		NS	v6ns1.$argv{domain}.
		AAAA	$argv{6}


EOF

my $coder          = JSON::PP->new->ascii->pretty->allow_nonref;
my $pretty_printed = $coder->pretty->encode( \%data );             # pretty-printing

open FILE, ">templates.js" or die "failed to create templates.js: $!";
print FILE <<"EOF";
// GENERATED OUTPUT run ./generate.pl to upate.
templates = $pretty_printed;
EOF

close FILE;

