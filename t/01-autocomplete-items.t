use strict;
use warnings;
use Test::More;
use t::lib::Harness qw(constructor_io);

plan tests => 3;

ok constructor_io->add(item_name => "item", autocomplete_section => "standard"), "Successfully added item";
ok constructor_io->modify(item_name => "item", new_item_name => "new item",
  autocomplete_section => "standard"), "Successfully modified item";
ok constructor_io->remove(item_name => "new item", autocomplete_section => "standard"), "Successfully removed item";
