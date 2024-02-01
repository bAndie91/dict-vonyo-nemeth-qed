#!/usr/bin/env perl

%dict = ();

while(<STDIN>)
{
	chomp;
	if(/^(\S.*)/)
	{
		$headword_eng = $1;
	}
	else
	{
		s/^\s*//;
		s/,,/„/g;
		s/''/”/g;
		
		my $remainder = '';
		
		for my $headword_hun (split /,/)
		{
			# in case when text with comma is between parentheses:
			$headword_hun = $remainder . $headword_hun;
			if($headword_hun =~ /\([^\)]+$/)
			{
				$remainder .= $headword_hun . ',';
				next;
			}
			$remainder = '';
			
			# strip leading/trailing whitespace
			$headword_hun =~ s/^\s*//;
			$headword_hun =~ s/\s*$//;
			next if $headword_hun eq '';
			
			# move parenthesized terms at the end
			$headword_hun =~ s/^((?:\([^\)]+\) )+)(.+)/$2 $1/;
			$dict{$headword_hun}->{$headword_eng} = 1;
		}
	}
}

for my $headword_hun (sort keys %dict)
{
	printf "%s\n%s", $headword_hun, join('', map {"\t$_\n"} sort keys %{$dict{$headword_hun}});
}
