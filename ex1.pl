:- module(db_leisure,_,[rfuzzy,clpr]).
% :- module(db_leisure,_,[rfuzzy, clpr, pkgs_output_debug]).
% Compilation time debug can be activated  by adding to the packages list [rfuzzy, clpr] the package pkgs_output_debug.
% Running time debug can be activated removing the comment marker % at the beginning of the following line.
% :- activate_rfuzzy_debug.

% Define the restaurants database format.
define_database(restaurant/7, 
	[(rest_name, rfuzzy_string_type), 
	  (restaurant_type, rfuzzy_enum_type), 
	   (food_type, rfuzzy_enum_type),
	    (years_since_opening, rfuzzy_integer_type), 
	     (distance_to_the_city_center, rfuzzy_integer_type), 
	      (price_average, rfuzzy_integer_type), 
	       (menu_price, rfuzzy_integer_type)]).

% restaurant(restaurant_name,                        2,        3,      4,          5,         6,        7, ).
%restaurant(rfuzzy_default_values, 1,        0,       null,      null,     null,       800).  <- nonsense ??
restaurant(kenzo,                           fast_casual,     japanese,           5,    null,       50,     null).
restaurant(burguer_king,               fast_food,        american,         10,    null,       10,     5).
restaurant(pizza_jardin,                 fast_casual,     italian,                5,    null,       15,     null).
restaurant(subway,                         fast_food,       sandwiches,        5,    null,      15,      10).
restaurant(derroscas,                     fast_food,        mediterranean,   3,    null,      25,      null).
restaurant(il_tempietto,                  fast_casual,    italian,                5,    null,       20,     null).
restaurant(kono_pizza,                   fast_food,       pizza,                  4,    null,      15,      null).
restaurant(paellador,                       fast_food,       paella,                8,     null,      40,     null).
restaurant(tapasbar,                        fast_food,       tapas,                 3,     null,      10,     null).
restaurant(meson_del_jamon,        fast_food,       spanish,              8,     100,      20,     15).
restaurant(museo_del_jamon,        fast_food,       spanish,              8,     150,      20,     15).
restaurant(zalacain,                         fine_dining,    basque,             15,     null,      60,     50).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

define_similarity_between(restaurant, food_type(spanish), food_type(tapas), 0.7).
define_similarity_between(restaurant, food_type(mediterranean), food_type(spanish), 0.8) cred (prod, 0.9).
define_similarity_between(restaurant, food_type(mediterranean), food_type(italian), 0.8) cred (prod, 0.9).
define_similarity_between(restaurant, food_type(spanish), food_type(mediterranean), 0.6) cred (prod, 0.9).
define_similarity_between(restaurant, food_type(italian), food_type(mediterranean), 0.6) cred (prod, 0.9).

near_the_city_center(restaurant) :~ defaults_to(0).
near_the_city_center(restaurant):~ function(distance_to_the_city_center(restaurant), [ (0, 1), (100, 1), (1000, 0.1) ]).

traditional(restaurant) :~ function(years_since_opening(restaurant), [ (0, 1), (5, 0.2), (10, 0.8), (15, 1), (100, 1) ]).
traditional(restaurant) :~ function(years_since_opening(restaurant), [ (0, 1), (5, 0.2), (10, 0.8), (15, 1), (100, 1) ]) only_for_user bartolo.

cheap(restaurant) :~ defaults_to(0.5).
cheap(restaurant) :~ defaults_to(0.2) if (near_the_city_center(restaurant) is_over 0.7).
cheap(restaurant) :~ value(0.1) if (rest_name(restaurant) equals zalacain).
cheap(restaurant) :~ function(price_average(restaurant), [ (0, 1), (10, 1), (15, 0.9), (20, 0.8), (30, 0.5), (50, 0.1), (100, 0) ]).

unexpensive(restaurant) :~ synonym_of(cheap(restaurant), prod, 1).
expensive(restaurant) :~ antonym_of(cheap(restaurant), prod, 1).

define_modifier(rather/2, TV_In, TV_Out) :-
	TV_Out .=. TV_In * TV_In.
define_modifier(very/2, TV_In, TV_Out) :-
	TV_Out .=. TV_In * TV_In * TV_In.
define_modifier(little/2, TV_In, TV_Out) :-
	TV_Out * TV_Out .=. TV_In.
define_modifier(very_little/2, TV_In, TV_Out) :-
	TV_Out * TV_Out * TV_Out .=. TV_In.

tempting_restaurant(restaurant) :~ defaults_to( 0.1).
tempting_restaurant(restaurant) :~ rule(min, (near_the_city_center(restaurant), fnot(very(expensive(restaurant))), very(traditional(restaurant)))) with_credibility (min, 0.7).
tempting_restaurant(restaurant) :~ rule(near_the_city_center(restaurant)) with_credibility (min, 0.5) .

% Define the films database format.
define_database(film/8, 
	[(film_name, rfuzzy_string_type), 
	  (release_year, rfuzzy_integer_type), 
	   (duration_in_minutes, rfuzzy_integer_type),
	    (genre, rfuzzy_enum_type), 
	     (original_language, rfuzzy_enum_type), 
	      (directed_by, rfuzzy_enum_type), 
	       (distributed_by, rfuzzy_enum_type),
		(not_for_children_under, rfuzzy_integer_type)]).

film('The Godfather', 1972, 207, drama, english, 'Francis Ford Coppola', 'Paramount Pictures', 12).
film('Casablanca', 1946, 172, romance, english, 'Michael Curtiz', 'Warner Bros', null).
film('Cera una volta il West', 1968, 165, western, italian, 'Sergio Leone', 'MYMONETRO', null).
film('El laberinto del fauno', 2006, 107, drama, spanish, 'Guillermo del Toro', 'Esperanto Films', 12).
film('Il buono, il brutto, il cattivo', 1967, 141, adventure, italian, 'Sergio Leone', 'United Artists', null).
film('Finding Nemo', 2003, 112, comedy, english, 'Andrew Stanton and Lee Unkrich', 'Disney - PIXAR', null).
film('Thor - The dark world', 2013, 90, action, english, 'Alan Taylor', 'Walt Disney Studios Motion Pictures', null).
film('Blue Jasmine', 2013, 98, action, english, 'Woody Allen', 'Warner Bros', null).
film('The Collection', 2013, 82, thriller, english, 'Marcus Dunstan', 'Alimpro Films', null).
film('Before Sunrise', 1995, 101, romantic_drama, english, 'Richard Linklater', 'Columbia Pictures', null).
film('Before Midnight', 2013, 109, romantic_drama, english, 'Richard Linklater', 'Sony Pictures Classics', null).
film('Quien mato a Bambi?', 2013, 89, comedy, spanish, 'Santi Amodeo', 'Sony Pictures', 12).
film('Not Suitable for Children', 2012, 96, romantic_comedy, english, 'Peter Templeman', 'Icon Film Distribution', null).
film('Alien vs Predator', 2004, 115, science_fiction, english, 'Paul W.S. Anderson', '20th Century Fox', 12).
film('Despicable Me', 2010, 95, comedy, english, 'Pierre Coffin and Chris Renaud', 'Universal Pictures', 0).
film('Despicable Me 2', 2013, 98, comedy, english, 'Pierre Coffin and Chris Renaud', 'Universal Pictures', 0).
film('Wall-E', 2008, 98, romantic_comedy, english, 'Andrew Stanton', 'Walt Disney Studios Motion Pictures', 0).
film('Ice Age', 2002, 81, computer-animated_comedy-drama_adventure, english, 'Carlos Saldanha and Chris Wedge', '20th Century Fox', 0).
film('Ice Age: The Meltdown', 2006, 91, computer-animated_comedy_adventure, english, 'Carlos Saldanha', '20th Century Fox', 0).
film('Ice Age: Dawn of the Dinosaurs', 2009, 94, computer-animated_comedy_adventure, english, 'Carlos Saldanha', '20th Century Fox', 0).
film('Ice Age: Continental Drift', 2012, 88, computer-animated_comedy_adventure, english, 'Steve Martino and Mike Thurmeier', '20th Century Fox', 0).
film('Shrek', 2001, 90, computer-animated_fantasy-comedy, english, 'Andrew Adamson and Vicky Jenson', 'DreamWorks Pictures', 0).
film('Shrek 2', 2004, 92, computer-animated_fantasy-comedy, english, 'Andrew Adamson, Kelly Asbury and Conrad Vernon', 'DreamWorks Pictures', 0).
film('Shrek 3', 2007, 93, computer-animated_fantasy-comedy, english, 'Chris Miller and Raman Hui', 'Paramount Pictures', 0).
film('Shrek Forever After', 2010, 93, computer-animated_fantasy-comedy, english, 'Mike Mitchell', 'Paramount Pictures', 0).

modern(film) :~ defaults_to( 1 ).
modern(film) :~ function(release_year(film), [ (1800, 0), (1970, 0), (2000, 0.1), (2010, 0.8)]).
long_duration(film) :~ defaults_to( 0 ).
long_duration(film) :~ function(duration_in_minutes(film), [ (120, 0), (180, 1), (600, 1)]) .

% similarity over genres
define_similarity_between(film, genre(drama), genre(drama), 1).
define_similarity_between(film, genre(drama), genre(romance), 0.6).
define_similarity_between(film, genre(drama), genre(western), 0.1).
define_similarity_between(film, genre(drama), genre(adventure), 0.1).
define_similarity_between(film, genre(drama), genre(comedy), 0).
define_similarity_between(film, genre(romance), genre(drama), 0.6).

define_similarity_between(film, genre(romance), genre(romance), 1).
define_similarity_between(film, genre(romance), genre(western), 0.4).
define_similarity_between(film, genre(romance), genre(adventure), 0.3).
define_similarity_between(film, genre(romance), genre(comedy), 0.3).
define_similarity_between(film, genre(western), genre(drama), 0.1).
define_similarity_between(film, genre(western), genre(romance), 0.4).

define_similarity_between(film, genre(western), genre(western), 1).
define_similarity_between(film, genre(western), genre(adventure), 0.8).
define_similarity_between(film, genre(western), genre(comedy), 0.1).
define_similarity_between(film, genre(adventure), genre(drama), 0.1).
define_similarity_between(film, genre(adventure), genre(romance), 0.3).
define_similarity_between(film, genre(adventure), genre(western), 0.8).

define_similarity_between(film, genre(adventure), genre(adventure), 1).
define_similarity_between(film, genre(adventure), genre(comedy), 0.2).
define_similarity_between(film, genre(comedy), genre(drama), 0).
define_similarity_between(film, genre(comedy), genre(romance), 0.3).
define_similarity_between(film, genre(comedy), genre(western), 0.1).
define_similarity_between(film, genre(comedy), genre(adventure), 0.2).
%define_similarity_between(film, genre(comedy), genre(comedy), 1.

% similarity over languages
% define_similarity_between(film, original_language(english), original_language(english), 1).
define_similarity_between(film, original_language(english), original_language(spanish), 0.2).
define_similarity_between(film, original_language(english), original_language(italian), 0.2).
define_similarity_between(film, original_language(spanish), original_language(english), 0.2).
% define_similarity_between(film, original_language(spanish), original_language(spanish), 1).
define_similarity_between(film, original_language(spanish), original_language(italian), 0.7).
define_similarity_between(film, original_language(italian), original_language(english), 0.2).
define_similarity_between(film, original_language(italian), original_language(spanish), 0.7).
% define_similarity_between(film, original_language(italian), original_language(italian), 1).

% funny is an example of a discrete attribute
funny(film) :~ value(0) if (genre(film) is_not comedy).
% funny(film) :~ value(0.2) if (genre(film) equals western).
funny(film) :~ value(0.4) if (genre(film) equals romance).
funny(film) :~ value(0.4) if (genre(film) equals adventure).
funny(film) :~ value(1) if (genre(film) equals comedy).

