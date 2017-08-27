
$K=3;
# number of blocks; plaintext must be a multiple of K, otherwise add spaces
# accomodate any amount of text?
# base sums < composite
$L=4;
# reverse block size for modularity (in this case K-1)

$ALPHABET=26;
$composite=77070841, $e=71782351, $d=75351775;
# composite, key (prime), inverse key

	@intarray = char_to_num("secret");
	@base_sums = array_to_graph(6, $K, @intarray);

sub main {
	$plainText="secret";
	
	$plainText = extraLength($plainText, $K); #add extra length

	# Variable declarations
	@base_sums;
	@encrypted_base_sums;
	@intarray;
	@encrypted_intarray;
	@mod;

	@intarray = char_to_num($plainText);
	@base_sums = array_to_graph(length($plainText), $K, @intarray);

	# Cycle thru and encrypt each n-graph
	for($i=0; $i < $#base_sums; $i++) {
		$encrypted_base_sums[$i] = ModExp($base_sums[$i], $e, $composite);
	}

	print $encrypted_base_sums[0];

	@mod = graph_to_array($encrypted_base_sums, $L);
	$cypherText = num_to_char($#encrypted_base_sums, $L, @mod);
	print "$cypherText";

	# ------------------------------- DECRYPT BEGIN --------------------------------*/
	$cypherText = extraLength($cypherText, $L);

	# Cooresponding variable declearations
	@ebase_sums;
	@pbase_sums;
	@eintarray;
	@pintarray;
	@emod;

	@eintarray = char_to_num($cypherText);
	@ebase_sums = array_to_graph(length($cypherText), $L, @eintarray);

	for($i=0; $i < $#ebase_sums; $i++) {
		$pbase_sums[$i] = ModExp($ebase_sums[$i], $d, $composite);
	}
		
	@emod = graph_to_array(@pbase_sums, $K);
	$plainText = num_to_char($#pbase_sums, $K, @emod);
	print $plainText;
}

# --------- ADD EXTRA SPACES AT END OF MESSAGE AND ALLOCATE ARRAY SIZES(1)---*/
sub extraLength {
	my ($text, $graph) = @_;
	$extralength=length($text) % $graph;
	if($extralength!=0) {
		for($i=0;$i < ($graph-$extralength);$i++) {
			$text=$text . " ";
		}
	}
	return $text;
		
}

	
# ------------------ CONVERT CHARS TO NUMERIC EQUIV (2)---------------------*/

sub char_to_num	{
	my $text = $_[0];

	@intarray;
	for($i=0; $i<length($text); $i++)
	{
		$ch=substr($text, $i, 1);
		# if else statement; logic is C, where the second OR argument doesn't evalute
		$intarray[$i]=ord($ch) if( $ch =~ /[A-Za-z0-9\s]/ ) || print "Message characters contains unusual characters \n";

	}

	return @intarray;

}



# ------------CONVERT N-GRAPHS INTO NUMBERS IN ARRAY (3)-----------------*/
# modify this with the inverse graph to array
# additional encrypt: alphabet, method of exponent; increases the effect of rsa (size of primes)
# side effect of a ratio between text size and composite field
sub array_to_graph {
	my ($textlength, $graph, @intarray) = @_;

	@base_sums;

	for($i=0; $i < ($textlength / $graph); $i++)
	{

		$base_sums[$i]=0;
		for($i2=$graph-1; $i2>=0; $i2--)
		{
			$radix=$ALPHABET ** $i2;
#translate char to num; basesums has 3 elements; intarray has variable amount of text
			$base_sums[$i]=$base_sums[$i] + ($intarray[($graph-1-$i2) + ($i*$graph)] * $radix);
		}
	}

print @basesums;
#print @intarray;
#ord() chr()
	return @base_sums;
}



# ---------------CONVERT NUMBERS IN ARRAY TO N-GRAPHS (4)----------------------*/
# converts encrypted numbers to encrypted text
sub graph_to_array {
	my (@encrypted_base_sums, $graph) = @_;

	$quotient=1;
	# 2D array
	@mod;
	@mod2;

	for ($i=0; $i < $#encrypted_base_sums; $i++) 
	{
		$quotient = $encrypted_base_sums[$i] / $ALPHABET;
		$mod[$i][0] = $encrypted_base_sums[$i] % $ALPHABET;

		for ($i2=1; $quotient!=0; $i2++)
		{
			$mod[$i][$i2] = $quotient % $ALPHABET;
			$quotient=$quotient / $ALPHABET;
			last if($quotient==0);
		}
	}
	for($i=0; $i < $#encrypted_base_sums; $i++) {
		for($i2=0; $i2 < $graph; $i2++) {
			$mod2[$i][$i2] = $mod[$i][$graph-1-$i2];
		}
	}
	return @mod2;
}

# -------------------- TURN NUMBERS BACK TO ENCRYPTED TEXT ------------------*/
sub num_to_char {
	my ($ebase_sums_length, $graph, @mod) = @_;

	@encrypted_intarray;
	@ch;
	$cypherText;

	for($i=0; $i < $ebase_sums_length; $i++)
	{
		for($i2=0; $i2 < $graph; $i2++)
		{
			$encrypted_intarray[$i2+($i*$graph)] = $mod[$i][$i2]  + 97;
		}
	}

	for($i=0; $i < $#encrypted_intarray; $i++) {
		$ch[$i] = $encrypted_intarray[$i];
	}
		
	$cypherText = @ch;
	return $cypherText;
}
	

# -------------------MODULAR EXPONENTIATION METHOD-------------------------*/
sub modexp {
	my ($base, $expon, $mod) = @_;
	for($rbase=1;$expon>0;$expon--) {
		$rbase=$rbase*$base;
		$rbase = $rbase % $mod;

	}
	return $rbase;
}

