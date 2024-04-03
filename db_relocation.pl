:- module(db_relocation,_,[rfuzzy,clpr]).
% Compilation time debug can be activated  by adding to the packages list [rfuzzy, clpr] the package pkgs_output_debug.
% Running time debug can be activated removing the comment marker % at the beginning of the following line.
% :- activate_rfuzzy_debug.

% TYPE DECLARATION
define_database(house/13, 
	[(code, rfuzzy_enum_type), 
	  (house_type, rfuzzy_enum_type), 
	   (size_in_m2, rfuzzy_integer_type),
	    (rooms_number, rfuzzy_integer_type), 
	     (number_of_bathrooms, rfuzzy_integer_type), 
	      (floor, rfuzzy_integer_type), 
	       (floors, rfuzzy_integer_type), 
		(number_of_elevators, rfuzzy_integer_type), 
		 (price, rfuzzy_integer_type), 
		  (distance_to_the_center_in_m, rfuzzy_integer_type), 
		   (distance_to_the_beach_in_m, rfuzzy_integer_type),
		    (distance_to_the_school_in_m, rfuzzy_integer_type),
		     (distance_to_the_gym_in_m, rfuzzy_integer_type)]).

% DATABASE
house(lfs2168,'apartment',          114,    5, 2,     3,   4, 1,      630000,      200,   5700, 1000,  1200).
house(lfs2144,'apartment',            77,    3, 1,     3, 11, 2,      420000,      700,   3500, 1500,  1100).
house(lfs2147,'apartment',            80,    2, 1,     2, 11, 3,      675000,    1200,     200,   500,    100).
house(lfs2145,'apartment',          224,    8, 3,     4,   4, 0,      790000,    2000,     100, 2000,  2300).
house(c358,'apartment',                74,    3, 1,     3,   4, 0,      340000,      500,   3100, 1000,  1500).
house(lfs2110,'apartment',          155,    9, 4,     3,   4, 2,    2500000,      800,   2400,   200,  2000).
house(lfs2124,'apartment',            63,    2, 1,     4,   4, 0,      275000,    1500,     450,   100,    200).
house(lfs2123,'apartment',            62,    3, 1,     1,   1, 0,      285000,    6000,   1000,   300,    500).
house(lfs2155,'villa',                  2300,    9, 4, null,   3, 1,    3000000,  13000,     800,  2000,  3000).
house(lfs2111,'villa',                    700,  10, 5, null,   3, 1,    1100000,    9000,   4500,  3000,  2500).
house(lfs2047,'villa',                  1750,  11, 5, null,   1, 0,    1650000,  15000,   1000,  5000,  5500).
house(lfs2041,'villa',                  4000,  13, 7, null,   2, 0,    2500000,    4000,   1800,  4000,  3000).
house(es13462,'villa',                  600,    6, 2, null,   2, 0,    4000000,    6000,   1500,  2000,  3000).
house(lfs1942,'villa',                    900,  10, 4, null,   2, 0,    3100000,    3000,   3400,  6000,  6000).
house(lfs1917,'villa',                    210,    5, 2, null,   3, 0,      590000,  13000,   5000,  7000,  7500).
house(lfb143,'villa',                    1200,    9, 3, null,   1, 0,    2750000,    7000,   4000,  1000,  1200).
house(5607/152,'town_house',    161,    7, 4, null,   3, 1,      815000,    6000,   1200,    300,    200).
house(es13340,'town_house',   1025,    8, 4, null,   1, 0,    2800000,  25000,   7000,    500,    400).
house(lfs1939,'town_house',       860,    9, 5, null,   2, 0,    1800000,  14000,   2400,  1000,  1200).
house(lfs1938,'town_house',       520,  11, 6, null,   2, 0,    1990000,  19000,       80,  3000,  3500).

% FUZZY FUNCTIONS OVER QUANTITATIVE ATTRIBUTES USING INFO FROM THE DATABASE
expensive(house) :~ function(price(house), [(50000,0),(100000,0.1),(250000,0.2),(350000,0.3),(450000,0.5),(550000,0.6),(800000,0.7),(1000000,0.8),(1500000,0.9),(2500000,1)]).
small(house) :~ function(size_in_m2(house), [(0,1),(50,1),(75,0.5),(100,0.2),(150,0.1),(200,0),(1000,0)]).
close_to_the_center(house) :~ function(distance_to_the_center_in_m(house), [(0,1),(300,1),(1000,0.9),(2000,0.5),(3000,0.2),(5000,0.1),(10000,0),(100000,0)]).
close_to_the_beach(house) :~ function(distance_to_the_beach_in_m(house), [(0,1),(5000,1),(10000,0.5),(50000,0.1)]).
close_to_the_school(house) :~ function(distance_to_the_school_in_m(house), [(0,1),(100,1),(1000,0.5),(2000,0)]).

cheap(house) :~ antonym_of(expensive(house), prod, 1).
big(house) :~ antonym_of(small(house), prod, 1).
far_from_the_center(house) :~ antonym_of(close_to_the_center(house), prod, 1).
far_from_the_beach(house) :~ antonym_of(close_to_the_beach(house), prod, 1).

unexpensive(house) :~ synonym_of(cheap(house), prod, 1).
huge(house) :~ rule(very(big(house))).

ideal_for_postgraduate_students(house) :~ defaults_to(0.2).
ideal_for_postgraduate_students(house) :~ rule(min, (fnot(very(expensive(house))), close_to_the_beach(house), close_to_the_center(house))).

ideal_for_families(house) :~ defaults_to(0.2).
ideal_for_families(house) :~ rule(min, (fnot(very(expensive(house))), close_to_the_center(house), close_to_the_school(house))).

