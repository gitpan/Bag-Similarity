requires 'perl', '5.008005';

# requires 'Some::Module', 'VERSION';
requires 'Carp', '0';

on test => sub {
    requires 'Test::More', '0.88';
    requires 'Test::Exception','0';
};
