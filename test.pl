$ENV{MPI_OPTIONS} //= "--hostfile ./debian/mpihostfile";

my $mpirun = "";
foreach my $mpi_try (qw(mpiexec mpirun)) {
    my $test = join("",`$mpi_try $ENV{MPI_OPTIONS} -n 1 perl -e "print qq{honk},qq{honk\n}"`);
    $mpirun = $mpi_try if $test =~ /honkhonk/;
    last if $mpirun;
}
$mpirun = $mpirun || "mpirun"; # fallback
my $incs;
$incs .= " -I$_" foreach @INC;
my @newout = sort {
    (($a =~ /(\d+)/g)[0] <=> ($b =~ /(\d+)/g)[0])
} `$mpirun $ENV{MPI_OPTIONS} -np 2 $^X $incs ic.pl`;
print "1..26\n";
if (@newout < 25) {
    print "not ok 1 # mpirun failed.  Do you need to start mpd?\n";
}
print @newout;
