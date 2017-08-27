main();


sub main {
	$n, $e, $phi, $d;
	# composite, random num, phi func, inverse	
	$prime1 = prime_func();
	$prime2 = prime_func();
print "$prime1 $prime2 \n";
	$n = $prime1 * $prime2;
	$phi = $n + 1 - $prime2 - $prime1;
		
	$e = random_number(32768);
	for (; gcd($e, $phi) != 1; $e--){}

	$d = inverse($phi, $e);
	$d = $d + $phi if($d <= 0);

	print "e is " . $e;
	print "\n d is " . $d;
	print "\n n is " . $n;

	print "\n final " . ($e*$d)%$phi;
}


sub prime_func {
	$p;
	$CONSTANT=5;

	$p = random_number(32768);
		
	$p++ if(0==$p % 2);  #make sure n is odd

	A: for(; ;$p = $p + 2)
	{
		B: for($b = random_number(16384), $i=0;;)
		{

			$b--; #base to test $p
			next if(gcd($b, $p) != 1);

			next A if(modexp($b, $p, $p) != $b);
			$i++;
			last A if($i >=CONSTANT);
			next B;
		}
	}
	return $p;
}


sub random_number {
	return int(rand(@_[0]));
}

sub modexp {
	my ($base, $expon, $mod) = @_;
	for($rbase=1;$expon>0;$expon--) {
		$rbase=$rbase*$base;
		$rbase = $rbase % $mod;

	}
	return $rbase;
}

# ----------- EUCLIDEAN ALGORITHM: FIND GCD ---------------------*/
sub gcd {
	my ($phi, $e) = @_;

	while($e!=0) #Euclidean algorithm with saved remainders and quotients
	{
		push @remander, ($phi % $e);
		push @quot, ($phi / $e);
		$phi = $e;
		$e = $remander[$i];
		$i++;
	}
#	print "$phi $e @remander";
	return $phi;
}

# ?
sub inverse {
	my ($phi, $e)=@_;
	$i=0;

	while($e!=0) #Euclidean algorithm with saved remainders and quotients
	{
		push @remander, ($phi % $e);
		push @quot, ($phi / $e);
		$phi = $e;
		$e = $remander[$i];
		$i++;
	}
		
	$i--;

	@c[$i];
	@d[$i];

	$c[0] = 1 + $quot[$i-1] * $quot[$i-2];
	$d[0] = -$quot[$i-1];

	for($i2=1; $i2+1<$i; $i2++) 
	{
		$c[$i2] = $d[$i2-1] - ($c[$i2-1] * $quot[$i-2-$i2]);
		$d[$i2] = $c[$i2-1];

	}

	return($c[$i2-1]); 

}


