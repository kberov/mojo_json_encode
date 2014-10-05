#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojo::JSON qw(encode_json);

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

my $user = {
  id         => 1,
  first_name => 'Красимир',
  last_name  => 'Беров',
  country    => 'България',
  language => 'Bulgarian',
};
app->helper(encode_json      => sub { encode_json($_[1]) });
app->helper(encode_json_text => sub { Mojo::JSON::_encode_value($_[1]) });

get '/' => sub {
  my $c = shift;

  $c->stash(user => $user);
  $c->render('index');
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
Welcome to the Mojolicious real-time web framework!
<p> Казвам се
  <span id="bg_name"></span> и съм от
  <span id="bg_country"></span>.
  Аз говоря <span id="bg_language"></span>
</p>
<p> My name is
  <span id="en_name"></span> and I am from
  <span id="en_country"></span>.
  I speak <span id="en_language"></span>
</p>

%= javascript begin
var user = <%== encode_json($user) %>;
var bg_user = <%== encode_json_text($user) %>;
jQuery(document).ready(function($){
  $('#bg_name').text(bg_user.first_name  + ' ' + bg_user.last_name);
  $('#bg_country').text(bg_user.country);
  $('#bg_language').text(bg_user.language);

  $('#en_name').text(user.first_name + ' ' + user.last_name);
  $('#en_country').text(user.country);
  $('#en_language').text(user.language);
});
%= end


@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head>
    <title><%= title %></title>
    %= javascript "/mojo/jquery/jquery.js"
  </head>
  <body><%= content %></body>
</html>
