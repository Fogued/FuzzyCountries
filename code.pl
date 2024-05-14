:- module(_,_,[rfuzzy, clpr]).

 %TODO: Define modifiers higher, lower, much higher, much lower, etc
 % Modifiers
define_modifier(rather/2, TV_In, TV_Out) :-
	TV_Out .=. TV_In * TV_In.
define_modifier(very/2, TV_In, TV_Out) :-
	TV_Out .=. TV_In * TV_In * TV_In.
define_modifier(little/2, TV_In, TV_Out) :-
	TV_Out * TV_Out .=. TV_In.
define_modifier(very_little/2, TV_In, TV_Out) :-
	TV_Out * TV_Out * TV_Out .=. TV_In.


% TYPE DECLARATION 
define_database(country/30,
[(country_number, rfuzzy_integer_type),
(country_name, rfuzzy_string_type),
(economic_freedom_index, rfuzzy_integer_type),
(surface_temperature, rfuzzy_integer_type),  % Datos del 2021
(suicides, rfuzzy_integer_type), % Por cada 100,000 habitantes
(people_percive_corruption, rfuzzy_integer_type),
(population_density, rfuzzy_integer_type), % Por cada km^2
(agricultural_land, rfuzzy_integer_type),
(land_area, rfuzzy_integer_type), % En km^2
(armed_forces_size, rfuzzy_integer_type),
(birth, rfuzzy_integer_type),
(co2_emissions, rfuzzy_integer_type),
(cpi, rfuzzy_integer_type), % Consumer price index
(fertility, rfuzzy_integer_type),
(forested_area, rfuzzy_integer_type),
(gdp, rfuzzy_integer_type), % Gross domestic product (PIB)
(gross_primary_education_enrollment, rfuzzy_integer_type),
(gross_tertiary_education_enrollment, rfuzzy_integer_type),
(infant_mortality, rfuzzy_integer_type),
(life_expectancy, rfuzzy_integer_type),
(population, rfuzzy_integer_type),
(labor_force, rfuzzy_integer_type), % Poblacion activa
(tax_revenue, rfuzzy_integer_type),
(unemployment, rfuzzy_integer_type),
(urban_population, rfuzzy_integer_type),
(latitude, rfuzzy_integer_type),
(longitude, rfuzzy_integer_type),
(renewables, rfuzzy_integer_type),
(minimum_wage, rfuzzy_integer_type),
(median_age, rfuzzy_integer_type)]).

% Las potencias utilizadas para redondear los float son, empezando desde la segunda columna [2, 2, 5, 3, 0, 1, 0, 0, 2, 0, 2, 2, 2, 0, 1, 1, 1, 1, 0, 1, 1, 2, 0, 5, 5, 5, 0, 0]

% economic_freedom_index, potencia 2
% surface_temperature, potencia 2
% suicides, potencia 5
% people_percive_corruption, potencia 3
% population_density, potencia 0
% agricultural_land, potencia 1
% land_area, potencia 0
% armed_forces_size, potencia 0
% birth, potencia 2
% co2_emissions, potencia 0
% cpi, potencia 2
% fertility, potencia 2
% forested_area, potencia 2
% gdp, potencia 0
% gross_primary_education_enrollment, potencia 1
% gross_tertiary_education_enrollment, potencia 1
% infant_mortality, potencia 1
% life_expectancy, potencia 1
% population, potencia 0
% labor_force, potencia 1
% tax_revenue, potencia 1
% unemployment, potencia 2
% urban_population, potencia 0
% latitude, potencia 5
% longitude, potencia 5
% renewables, potencia 5
% minimum_wage, potencia 0
% median_age, potencia 0

country(0  ,'Algeria'      ,482 ,2392 , 368333 ,752 ,  18 ,174 ,2381741 ,317000 ,2428 , 150006 ,15136 ,302 ,  80 , 169988236398 ,1099 , 514 ,201 ,767 , 43053054 ,412 ,372 , 117 , 31510100 ,28.033886 ,1.659626  , 261367 , 2163 ,29).
country(1  ,'Argentina'    ,477 ,1540 , 870290 ,834 ,  17 ,543 ,2780400 ,105000 ,1702 , 201348 ,23275 ,226 , 980 , 449663446954 ,1097 , 900 , 88 ,765 , 44938712 ,613 ,101 , 979 , 41339571 ,-3841610  ,-6361667  ,1132925 , 7108 ,32).
country(2  ,'Australia'    ,805 ,2205 ,1065003 ,442 ,   3 ,482 ,7741220 , 58000 ,1260 , 375908 ,11980 ,174 ,1630 ,1392680589329 ,1003 ,1131 , 31 ,827 , 25766605 ,655 ,230 , 527 , 21844756 ,-2527440  ,13377514  ,1293353 ,30152 ,38).
country(3  ,'Austria'      ,769 , 741 ,1653923 ,481 , 109 ,324 ,  83871 , 21000 , 970 ,  61448 ,11806 ,147 ,4690 , 446314739528 ,1031 , 851 , 29 ,816 ,  8877067 ,607 ,254 , 467 ,  5194416 ,4751623   ,1455007   ,3748179 ,    0 ,43).
country(4  ,'Azerbaijan'   ,599 ,1390 , 473333 ,506 , 123 ,577 ,  86600 , 82000 ,1400 ,  37620 ,15632 ,173 ,1410 ,  39207000000 , 997 , 277 ,192 ,729 , 10023318 ,665 ,130 , 551 ,  5616165 ,4014310   ,4757693   , 220154 , 1744 ,32).
country(5  ,'Bangladesh'   ,581 ,2570 , 495000 ,682 ,1265 ,706 , 148460 ,221000 ,1818 ,  84246 ,17968 ,204 ,1100 , 302571254131 ,1165 , 206 ,251 ,723 ,167310838 ,590 , 88 , 419 , 60987417 ,2368499   ,9035633   ,  65015 ,  224 ,28).
country(6  ,'Belarus'      ,623 , 733 ,4230710 ,627 ,  47 ,420 , 207600 ,155000 , 990 ,  58280 ,    0 ,145 ,4260 ,  63080457023 ,1005 , 874 , 26 ,742 ,  9466856 ,641 ,147 , 459 ,  7482982 ,5370981   ,2795339   ,  96986 , 2052 ,40).
country(7  ,'Belgium'      ,743 ,1048 ,2034690 ,646 , 383 ,446 ,  30528 , 32000 ,1030 ,  96889 ,11711 ,162 ,2260 , 529606710418 ,1039 , 797 , 29 ,816 , 11484055 ,536 ,240 , 559 , 11259082 ,5050389   ,446994    , 933641 ,22565 ,42).
country(8  ,'Brazil'       ,658 ,2557 , 469000 ,756 ,  25 ,339 ,8515770 ,730000 ,1392 , 462299 ,16740 ,173 ,5890 ,1839758040766 ,1154 , 513 ,128 ,757 ,212559417 ,639 ,142 ,1208 ,183241641 ,-1423500  ,-5192528  ,4621975 , 3644 ,33).
country(9  ,'Bulgaria'     ,746 ,1197 ,1350620 ,932 ,  64 ,463 , 110879 , 31000 , 890 ,  41708 ,11442 ,156 ,3540 ,  86000000000 , 893 , 710 , 59 ,749 ,  6975761 ,554 ,202 , 434 ,  5256027 ,4273388   ,2548583   ,1148653 , 4399 ,45).
country(10 ,'Canada'       ,798 , 370 ,1125687 ,415 ,   4 , 69 ,9984670 , 72000 ,1010 , 544894 ,11676 ,150 ,3820 ,1736425629520 ,1009 , 689 , 43 ,819 , 36991981 ,651 ,128 , 556 , 30628482 ,5613037   ,-10634677 ,2988844 ,21920 ,41).
country(11 ,'Chile'        ,766 , 981 ,1011173 ,830 ,  26 ,212 , 756096 ,122000 ,1243 ,  85822 ,13191 ,165 ,2430 , 282318159745 ,1014 , 885 , 62 ,800 , 18952038 ,626 ,182 , 709 , 16610135 ,-3567515  ,-7154297  ,2651888 , 6039 ,35).
country(12 ,'Colombia'     ,660 ,2497 , 417000 ,841 ,  46 ,403 ,1138910 ,481000 ,1488 ,  97814 ,14095 ,181 ,5270 , 323802808108 ,1145 , 553 ,122 ,771 , 50339443 ,688 ,144 , 971 , 40827302 ,457087    ,-7429733  ,3302041 , 4317 ,31).
country(13 ,'Croatia'      ,725 ,1219 ,1846353 ,939 ,  73 ,276 ,  56594 , 18000 , 900 ,  17488 ,10982 ,147 ,3440 ,  60415553039 , 965 , 679 , 40 ,781 ,  4067500 ,512 ,220 , 693 ,  2328318 ,4510000   ,1520000   ,2827194 , 6798 ,44).
country(14 ,'Denmark'      ,810 , 896 ,1474940 ,179 , 137 ,620 ,  43094 , 15000 ,1060 ,  31786 ,11035 ,173 ,1470 , 348078018464 ,1013 , 806 , 36 ,810 ,  5818553 ,622 ,324 , 491 ,  5119978 ,5626392   ,950178    ,3924958 ,    0 ,42).
country(15 ,'Ecuador'      ,646 ,2142 ,1001277 ,843 ,  71 ,222 , 283561 , 41000 ,1972 ,  41155 ,12414 ,243 ,5020 , 107435665000 ,1033 , 449 ,122 ,768 , 17373662 ,680 ,220 , 397 , 11116711 ,-183124   ,-7818341  ,3235420 , 5200 ,28).
country(16 ,'Estonia'      ,795 , 630 ,2147177 ,527 ,  31 ,231 ,  45228 ,  6000 ,1090 ,  16590 ,12214 ,159 ,5130 ,  31386949981 , 972 , 696 , 21 ,782 ,  1331824 ,636 ,209 , 511 ,   916024 ,5859527   ,2501361   ,1432505 , 7877 ,42).
country(17 ,'Finland'      ,781 , 234 ,2118197 ,186 ,  18 , 75 , 338145 , 25000 , 860 ,  45871 ,11233 ,141 ,7310 , 268761201365 ,1002 , 882 , 14 ,817 ,  5520314 ,591 ,208 , 659 ,  4716888 ,6192411   ,2574815   ,3461129 ,    0 ,43).
country(18 ,'France'       ,740 ,1158 ,1863033 ,571 , 119 ,524 , 643801 ,307000 ,1130 , 303276 ,11005 ,188 ,3120 ,2715518274227 ,1025 , 656 , 34 ,825 , 67059887 ,551 ,242 , 843 , 54123364 ,4622764   ,221375    ,1367101 ,21142 ,42).
country(19 ,'Germany'      ,773 , 949 ,1286067 ,460 , 240 ,477 , 357022 ,180000 , 950 , 727973 ,11285 ,156 ,3270 ,3845630030824 ,1040 , 702 , 31 ,809 , 83132799 ,608 ,115 , 304 , 64324835 ,5116569   ,1045153   ,1945312 ,22525 ,46).
country(20 ,'Greece'       ,694 ,1509 , 366667 ,823 ,  81 ,476 , 131957 ,146000 , 810 ,  62434 ,10187 ,135 ,3170 , 209852761469 , 996 ,1366 , 36 ,813 , 10716322 ,518 ,262 ,1724 ,  8507474 ,3907421   ,2182431   ,1939167 ,10731 ,46).
country(21 ,'Hungary'      ,736 ,1158 ,2541990 ,876 , 107 ,584 ,  93028 , 40000 , 960 ,  45537 ,12164 ,154 ,2290 , 160967157504 ,1008 , 485 , 36 ,758 ,  9769949 ,565 ,230 , 340 ,  6999582 ,4716249   ,1950330   , 681957 , 7040 ,43).
country(22 ,'Iceland'      ,793 , 243 ,1244790 ,673 ,   3 ,187 , 103000 ,     0 ,1200 ,   2065 ,12900 ,171 ,  50 ,  24188035739 ,1004 , 718 , 15 ,827 ,   361313 ,750 ,233 , 284 ,   339110 ,6496305   ,-1902084  ,8687454 ,    0 ,37).
country(23 ,'Indonesia'    ,693 ,2601 , 289667 ,867 , 151 ,315 ,1904569 ,676000 ,1807 , 563325 ,15118 ,231 ,4990 ,1119190780753 ,1064 , 363 ,211 ,715 ,270203917 ,675 ,102 , 469 ,151509724 ,-78928    ,11392133  ,1038571 , 2619 ,30).
country(24 ,'Iraq'         ,549 ,2421 , 383333 ,875 ,  93 ,214 , 438317 ,209000 ,2908 , 190061 ,11986 ,367 , 190 , 234094042939 ,1087 , 162 ,225 ,705 , 39309783 ,430 , 20 ,1282 , 27783368 ,3322319   ,4367929   , 150249 , 2534 ,21).
country(25 ,'Israel'       ,757 ,2086 , 549667 ,753 , 400 ,246 ,  20770 ,178000 ,2080 ,  65166 ,10815 ,309 , 770 , 395098666122 ,1049 , 634 , 30 ,828 ,  9053300 ,640 ,231 , 386 ,  8374393 ,3104605   ,3485161   , 513229 ,17667 ,30).
country(26 ,'Italy'        ,725 ,1352 , 673713 ,866 , 206 ,432 , 301340 ,347000 , 730 , 320411 ,11062 ,129 ,3180 ,2001244392042 ,1019 , 619 , 26 ,829 , 60297396 ,496 ,243 , 989 , 42651966 ,4187194   ,1256738   ,1836226 ,    0 ,47).
country(27 ,'Japan'        ,779 ,1245 ,2403497 ,638 , 347 ,123 , 377944 ,261000 , 740 ,1135886 ,10548 ,142 ,6850 ,5081769542380 , 988 , 632 , 18 ,842 ,126226568 ,617 ,119 , 229 ,115782416 ,3620482   ,13825292  ,1142900 ,15112 ,48).
country(28 ,'Kazakhstan'   ,713 , 783 ,3859753 ,733 ,   7 ,804 ,2724900 , 71000 ,2177 , 247207 ,18275 ,284 , 120 , 180161741180 ,1044 , 617 , 88 ,732 , 18513930 ,688 ,117 , 459 , 10652915 ,4801957   ,6692368   , 398857 , 1041 ,31).
country(29 ,'Latvia'       ,771 , 682 ,2414840 ,800 ,  30 ,311 ,  64589 ,  6000 ,1000 ,   7004 ,11686 ,160 ,5400 ,  34117202555 , 994 , 881 , 33 ,747 ,  1912789 ,614 ,229 , 652 ,  1304943 ,5687964   ,2460319   ,2391737 , 6088 ,44).
country(30 ,'Luxembourg'   ,791 , 977 ,1526737 ,386 , 242 ,537 ,   2586 ,  2000 ,1030 ,   8988 ,11509 ,137 ,3570 ,  71104919108 ,1023 , 192 , 19 ,821 ,   645397 ,593 ,265 , 536 ,   565488 ,4981527   ,612958    , 709517 ,29374 ,49).
country(31 ,'Malaysia'     ,719 ,2647 , 443000 ,839 ,  99 ,263 , 329847 ,136000 ,1675 , 248289 ,12146 ,200 ,6760 , 364701517788 ,1053 , 451 , 67 ,760 , 32447385 ,643 ,120 , 332 , 24475766 ,421048    ,10197577  , 805984 , 2566 ,30).
country(32 ,'Mexico'       ,702 ,2185 , 405000 ,799 ,  66 ,546 ,1964375 ,336000 ,1760 , 486406 ,14154 ,213 ,3390 ,1258286717125 ,1058 , 402 ,110 ,750 ,126014024 ,607 ,131 , 342 ,102626859 ,2363450   ,-10255278 ,1051475 , 2725 ,29).
country(33 ,'New Zealand'  ,843 ,1118 ,1317157 ,242 ,  18 ,405 , 268838 ,  9000 ,1198 ,  34382 ,11424 ,171 ,3860 , 206928765544 ,1000 , 820 , 47 ,819 ,  4841000 ,699 ,290 , 407 ,  4258860 ,-4090056  ,17488597  ,4021865 ,27881 ,38).
country(34 ,'Norway'       ,767 , 211 ,1278203 ,270 ,  15 , 27 , 323802 , 23000 ,1040 ,  41023 ,12027 ,156 ,3320 , 403336363636 ,1003 , 820 , 21 ,828 ,  5347896 ,638 ,239 , 335 ,  4418218 ,6047202   ,846895    ,7155836 ,    0 ,40).
country(35 ,'Pakistan'     ,598 ,2203 , 909450 ,787 , 287 ,478 , 796095 ,936000 ,2825 , 201150 ,18232 ,351 , 190 , 304400000000 , 943 ,  90 ,572 ,671 ,216565318 ,526 , 92 , 445 , 79927762 ,3037532   ,6934512   ,1062290 , 1724 ,23).
country(36 ,'Peru'         ,752 ,1979 , 269333 ,891 ,  26 ,185 ,1285216 ,158000 ,1795 ,  57414 ,12978 ,225 ,5770 , 226848050820 ,1069 , 707 ,111 ,765 , 32510453 ,776 ,143 , 331 , 25390339 ,-918997   ,-7501515  ,2774101 , 3423 ,31).
country(37 ,'Philippines'  ,701 ,2670 , 197800 ,742 , 368 ,417 , 300000 ,153000 ,2055 , 122287 ,12961 ,258 ,2780 , 376795508680 ,1075 , 355 ,225 ,711 ,108116615 ,596 ,140 , 215 , 50975903 ,1287972   ,12177402  ,1090163 , 2770 ,26).
country(38 ,'Poland'       ,712 , 875 ,1733693 ,735 , 124 ,469 , 312685 ,191000 ,1020 , 299037 ,11411 ,146 ,3090 , 592164400688 ,1000 , 678 , 38 ,776 , 37970874 ,567 ,174 , 347 , 22796574 ,5191944   ,1914514   , 776169 , 8254 ,42).
country(39 ,'Portugal'     ,754 ,1610 ,1163907 ,887 , 111 ,395 ,  92212 , 52000 , 850 ,  48742 ,11062 ,138 ,3460 , 237686075635 ,1062 , 639 , 31 ,813 , 10269417 ,588 ,228 , 633 ,  6753579 ,3939987   ,-822445   ,3270395 , 9910 ,46).
country(40 ,'Romania'      ,770 ,1035 ,1305893 ,938 ,  84 ,588 , 238391 ,126000 , 960 ,  69259 ,12378 ,171 ,3010 , 250077444017 , 852 , 494 , 61 ,754 , 19356544 ,547 ,146 , 398 , 10468793 ,4594316   ,2496676   ,1748103 , 6163 ,43).
country(41 ,'Slovenia'     ,723 ,1000 ,2815140 ,806 , 103 ,307 ,  20273 ,  7000 , 940 ,  12633 ,11105 ,160 ,6200 ,  53742159517 ,1004 , 786 , 17 ,810 ,  2087946 ,584 ,186 , 420 ,  1144654 ,4615124   ,1499546   ,1876845 ,12553 ,45).
country(42 ,'South Africa' ,653 ,1806 ,2371253 ,860 ,  49 ,798 ,1219090 , 80000 ,2051 , 476644 ,15893 ,241 , 760 , 351431649241 ,1009 , 224 ,285 ,639 , 58558270 ,560 ,275 ,2818 , 39149717 ,-3055948  ,2293751   , 340861 , 3511 ,28).
country(43 ,'Spain'        ,752 ,1431 , 753647 ,745 ,  94 ,526 , 505370 ,196000 , 790 , 244002 ,11096 ,126 ,3690 ,1394116310769 ,1027 , 889 , 25 ,833 , 47076781 ,575 ,142 ,1396 , 37927409 ,4046367   ,-374922   ,2234166 ,15687 ,45).
country(44 ,'Sri Lanka'    ,613 ,2740 ,1838990 ,863 , 341 ,437 ,  65610 ,317000 ,1583 ,  23362 ,15553 ,220 ,3290 ,  84008783756 ,1002 , 196 , 64 ,768 , 21803000 ,539 ,119 , 420 ,  4052088 ,787305    ,8077180   ,2140453 ,  787 ,34).
country(45 ,'Sweden'       ,781 , 308 ,1501253 ,237 ,  25 , 74 , 450295 , 30000 ,1140 ,  43252 ,11051 ,176 ,6890 , 530832908738 ,1266 , 670 , 22 ,825 , 10285453 ,646 ,279 , 648 ,  9021165 ,6012816   ,1864350   ,5092401 ,    0 ,41).
country(46 ,'Switzerland'  ,847 , 639 ,1891830 ,292 , 219 ,384 ,  41277 , 21000 ,1000 ,  34477 , 9955 ,152 ,3180 , 703082435360 ,1052 , 596 , 37 ,836 ,  8574832 ,683 ,101 , 458 ,  6332428 ,4681819   ,822751    ,3671664 ,34284 ,43).
country(47 ,'Thailand'     ,707 ,2690 , 892977 ,895 , 137 ,433 , 513120 ,455000 ,1034 , 283763 ,11327 ,153 ,3220 , 543649976166 , 998 , 493 , 78 ,769 , 69625582 ,673 ,149 ,  75 , 35294600 ,1587003   ,10099254  , 711362 , 3034 ,40).
country(48 ,'Ukraine'      ,617 , 937 ,3193023 ,924 ,  75 ,717 , 603550 ,297000 , 870 , 202250 ,28166 ,130 ,1670 , 153781069118 , 990 , 827 , 75 ,716 , 44385155 ,542 ,201 , 888 , 30835699 ,4837943   ,3116558   , 610084 , 2131 ,41).


%%%%%%%%%%%% FUZZY FUNCTIONS %%%%%%%%%%%%%%%

% VALORES LOGICOS
% Economic freedom index
high_economic_freedom(country) :~ function(economic_freedom_index(country), [(400,0),(500,0.2),(600,0.4),(700,0.6),(800,0.8),(900,1)]).

% VALORES LOGICOS
% Surface temperature
risk_high_temperature(country) :~ function(surface_temperature(country), [(200,0),(2800,1)]).

% VALORES LOGICOS
% Suicide rate
alarming_suicide_rate(country) :~ function(suicides(country), [(200000,0),(300000,0.1),(400000,0.2),(500000,0.2),(6000000,1)]) with_credibility (max, 0.1).

% VALORES LOGICOS
% People Perceive Corruption
high_corruption_concern(country) :~ function(people_percive_corruption(country), [(0,0),(200,0.1),(400,0.25),(600,0.35),(900, 0.8),(1200,1)]).

% VALORES LOGICOS
% Population density (Personas por km^2)
dangerous_population_density(country) :~ function(population_density(country), [(10,0),(30,0.2),(80,0.4),(150,0.6),(200,0.8),(600,1)]) with_credibility (prod, 0.9).

% VALORES LOGICOS
% Agricultural Land (Percentage) //RULE W/ TEMPERATURE
huge_agricultural_land_percentage(country) :~ function(agricultural_land(country), [(50,0),(800,1)]).

% VALORES LOGICOS
% Land Area /// No hay una rule con ella
extensive_surface(country) :~ function(land_area(country), [(50000,0),(1000000,0.7),(9000000,1)]).

% VALORES LOGICOS
% DA 0 A: ISLANDIA (TIENE 0 EN LA TABLA)
% Armed Force Size
strong_armed_forces_rate(country) :~ function(armed_forces_size(country), [(1000,0),(50000, 0.4),(600000,0.7),(1500000,1)]).

% VALORES LOGICOS
% Birth rate
high_birth_rate(country) :~ function(birth(country), [(700,0.2),(3200,1)]).

% VALORES LOGICOS
% C02 emissions
critical_co2(country) :~ function(co2_emissions(country), [(0,0),(2000,0.1),(50000,0.3),(100000,0.45),(200000,0.6),(300000,0.8),(1300000,1)]).

% VALORES LOGICOS
% DA 0 A: VIELORRUSIA (0 EN LA TABLA)
% cpi
high_cpi_rate(country) :~ function(cpi(country), [(2500,0.1), (5000,0.2), (7500,0.3), (10000,0.4), (12500,0.6), (15000,0.8), (25000,0.95), (50000,1)]).

% VALORES LOGICOS
% fertility_rate
high_fertility_rate(country) :~ function(fertility(country), [(50,0), (100,0.2), (150,0.4), (200,0.5), (250,0.7), (300,0.8), (600, 1)]).

% VALORES LOGICOS
% forested_area
vast_forested_area_percentage(country) :~ function(forested_area(country), [(0,0), (1100, 0.2), (2200, 0.4), (3300, 0.5), (4400, 0.8), (6000, 0.8), (7000, 0.9), (7310, 0.95)]).

% VALORES LOGICOS
%GDP 
wealthy_gdp_per_capita(country) :~ function(gdp(country), [(10000000000,0.1), (100000000000,0.3), (600000000000,0.4), (800000000000,0.6), (1500000000000,0.7), (1750000000000,0.8), (2750000000000,0.9), (4500000000000,0.95), (6000000000000,0.99)]).

%Gross primary education errollment (Percentage)
%Enrollment indicators are based on annual school surveys, but do not necessarily reflect actual attendance or dropout rates during the year. Also, the length of education differs
%across countries and can influence enrollment rates, although the International Standard Classification of Education (ISCED) tries to minimize the difference. 
%For example, a shorter duration for primary education tends to increase the rate; a longer one to decrease it (in part because older 
%children are more at risk of dropping out). Moreover, age at enrollment may be inaccurately estimated or misstated, especially in communities where registration of births is not strictly enforced.

% VALORES LOGICOS (NO ESTA EN PORCENTAJE, HABLAREMOS DESPUES DE LA INTERPRETACION DE LOS RESULTADOS DE LAS FUNCIONES DIFUSAS)
high_education_primary(country) :~ function(gross_primary_education_enrollment(country), [(0,0), (700,0.1), (800,0.2), (900,0.4), (950,0.6), (1000,0.8), (1800,1)]).

% VALORES LOGICOS (LO MISMO QUE CON EDUCACION PRIMARIA)
%Gross Tertiary Education Enrollment (Percentage)
high_education_tertiary(country) :~ function(gross_tertiary_education_enrollment(country), [(0, 0), (100,0.15), (200,0.2), (300,0.4), (400,0.5), (500,0.6), (600,0.7), (900, 0.9), (1000, 1), (2000, 1)]).

% VALORES LOGICOS
%Infant mortality
infant_mortality_rate(country) :~ function(infant_mortality(country), [(0,0), (20,0.1), (50,0.2), (100,0.4), (150,0.6), (200,0.8), (250,0.85), (600, 1)]).

% VALORES LOGICOS
%Life expectancy
life_expectancy_rate(country) :~ function(life_expectancy(country), [(350,0), (400,0.2), (550,0.4), (600,0.6), (750,0.8), (900,1)]).

% VALORES LOGICOS
%Population
citizens(country) :~ function(population(country), [(0,0), (10000000,0.2), (20000000,0.4), (30000000,0.5), (40000000,0.55), (50000000,0.7), (80000000, 0.9), (220000000, 1), (280000000, 1)]).

% VALORES LOGICOS
%Población activa (porcentaje)
active_workers(country) :~ function(labor_force(country), [(400,0),(450,0.2),(550,0.4),(650,0.6),(750,0.8),(800,1)]).

% VALORES LOGICOS
%Tax revenue: porcentaje del PIB
tax_revenue_percentage(country) :~ function(tax_revenue(country), [(0,0),(80,0.25),(150,0.4),(200,0.6),(250,0.65),(300,0.8), (500, 1)]).

% VALORES LOGICOS
%Unemployment rate
unemployment_rate(country) :~ function(unemployment(country), [(0,0),(300,0.2),(500,0.4),(700,0.5),(1000,0.8),(3000,1)]).

% VALORES LOGICOS
%Urban population (valores totales, no porcentajes)
urban_pop(country) :~ function(urban_population(country), [(0,0),(5000000,0.1),(10000000,0.4),(40000000,0.6),(60000000,0.8),(120000000,0.9), (200000000, 1)]).

 %Latitude y longitud
 %Creo que no tiene sentido una funcion difusa (no hay mucho o poco, etc) Ademas hay valores negativos

% VALORES LOGICOS
%Renewables (porcentaje del total de energía)
renewable_energy(country) :~ function(renewables(country), [(0,0), (100000,0.1),(300000,0.2),(1000000,0.4),(1800000,0.6),(3500000,0.8),(8500000,0.9), (10000000,1)]).

% LA TIENEN A 0 EN LA TABLA: SUECIA, NORUEGA, ITALIA, ISLANDIA, FINLANDIA, DINAMARCA, AUSTRIA
% VALORES LOGICOS
%Minimum wage (en dólares)
min_wage(country) :~ function(minimum_wage(country), [(0,0), (1000,0.2),(5000,0.3),(10000,0.5),(20000,0.7),(30000,0.9), (40000, 1)]).

% VALORES LOGICOS
%Median age
mid_age(country) :~ function(median_age(country), [(0,0), (20,0.1),(25,0.2),(30,0.4),(35,0.6),(40,0.8),(45,0.9), (50, 1)]).


 %%%%%%%%%% RULES %%%%%%%%%%  

%Pais limpio: Energia renovable, Poblacion urbana, Porcentaje de tierra agricola, Porcentaje de tierra forestal, Emisiones de co2
clean_country(country) :~ rule(mean, ((renewable_energy(country)), (urban_pop(country), (huge_agricultural_land_percentage(country), (vast_forested_area_percentage(country)), (critical_co2(country)) )))) with_credibility (min, 0.7).

%Pais medioambientalmente amigable: Energia renovable, Emisiones de co2, Porcentaje de tierra agricola, Porcentaje de tierra forestal
environmentally_friendly_country(country) :~ rule(mean, ((renewable_energy(country)), (critical_co2(country), (vast_forested_area_percentage(country)), (huge_agricultural_land_percentage(country))))) with_credibility (min, 0.7).

%Pais avanzado: PBI per capita, Esperanza de vida, Mortalidad infantil, Libertad economica
developed_country(country) :~ rule(mean, ((wealthy_gdp_per_capita(country)), (life_expectancy_rate(country)), fnot((infant_mortality_rate(country))), (high_economic_freedom(country)))) with_credibility (min, 0.7).

%Politica estable: Libertad economica, Percepcion de corrupcion	
political_stable_country(country) :~ rule(mean, ((high_economic_freedom(country)), fnot(high_corruption_concern(country)))) with_credibility (min, 0.7).

%Pais con alta calidad de vida: Esperanza de vida, Tasa de suicidios
high_quality_of_life_country(country) :~ rule(mean, ((life_expectancy_rate(country)), fnot(alarming_suicide_rate(country)))) with_credibility (min, 0.7).

%Sistema educativo fuerte: Educación Primaria, Educación Terciaria y Tasa Desempleo
strong_education_system(country) :~ rule(mean, ((high_education_primary(country)), (high_education_tertiary(country)), fnot(unemployment_rate(country)))) with_credibility (min, 0.7).

%Crecimiento poblacional bajo: Nacimientos, Fertilidad, Mortalidad infantil
low_population_growth_country(country) :~ rule(mean, (fnot(high_birth_rate(country)), fnot(high_fertility_rate(country)), (infant_mortality_rate(country)))) with_credibility (max, 0.7).

%Pais urbanizado: Población urbana, Porcentaje de tierra agricola, Densidad de población, Porcentaje de tierra forestal
urbanized_country(country) :~ rule(mean, ((urban_pop(country)), fnot(huge_agricultural_land_percentage(country)), (dangerous_population_density(country)), fnot(vast_forested_area_percentage(country)))) with_credibility (min, 0.7).

%Pais con gran fuerza militar: Tasa fuerzas armadas, Densidad
militarily_strong_country(country) :~ rule(mean, ((strong_armed_forces_rate(country)), (dangerous_population_density(country)))) with_credibility (min, 0.7).

%Pais economicamente estable: Tasa de inflacion, Tasa de desempleo
economically_stable_country(country) :~ rule(mean, (fnot(high_cpi_rate(country)), fnot(unemployment_rate(country)))) with_credibility (min, 0.7).

%Pais con grandes ingresos: PBI per capita, Sueldo minimo
high_income_country(country) :~ rule(mean, ((wealthy_gdp_per_capita(country)), (min_wage(country)))) with_credibility (prod, 0.9).

%Pais con poblacion envejecida: Edad media, Tasa de natalidad, Poblacion
aging_population_country(country) :~ rule(mean, (mid_age(country), high_birth_rate(country), citizens(country))) with_credibility (min, 0.7).

%Pais con alta calidad de salud: Tasa de mortalidad infantil, Esperanza de vida
quality_healthcare_country(country) :~ rule(mean, (fnot(infant_mortality_rate(country)), (life_expectancy_rate(country)))) with_credibility (min, 0.7).

%Pais sostenible: Porcentaje de tierra agricola, Emisiones de CO2, Porcentaje de tierras agricolas, Porcentaje de tierras forestales, Tasa de natalidad
sustainable_country(country) :~ rule(mean, ((vast_forested_area_percentage(country)), fnot(critical_co2(country)), huge_agricultural_land_percentage(country), (renewable_energy(country))) ) with_credibility (min, 0.7).

%Pais atractivo para el turismo: Temperatura, Porcentaje de tierra forestal, Esperanza de vida, Tasa de mortalidad infantil, PBI per capita, Poblacion urbana
attractive_tourism_destination(country) :~ rule(mean, ((risk_high_temperature(country)), (vast_forested_area_percentage(country)), (life_expectancy_rate(country)), fnot(infant_mortality_rate(country)), wealthy_gdp_per_capita(country), urban_pop(country))) with_credibility (min, 0.7).

%Pais economicamente resiliente: PBI per capita, Tasa de inflacion, Libertad economica, Porcentaje de ingresos fiscales, Tasa de desempleo, Poblacion activa, Tasa de fuerzas armadas
% economically_resilient_country(country) :~ rule(mean, ((wealthy_gdp_per_capita(country)), (high_cpi_rate(country)), (high_economic_freedom(country)), (tax_revenue_percentage(country)), (unemployment_rate(country)), (active_workers(country)), strong_armed_forces_rate(country))) with_credibility (min, 0.7).

%Pais socialmente conectado: Poblacion urbana, Densidad de poblacion, Ciudadania, Educacion primaria, Educacion terciaria, Tasa de mortalidad infantil, Esperanza de vida
% socially_connected_country(country) :~ rule(mean, ((urban_pop(country)), (dangerous_population_density(country)), (citizens(country)), (high_education_primary(country)), (high_education_tertiary(country)), (infant_mortality_rate(country)), (life_expectancy_rate(country)))) with_credibility (min, 0.7).

%Participacion ciudadana activa: Porcentaje de ingresos fiscales, Ciudadania, Libertad economica, Percepcion de corrupcion
active_civic_participation_country(country) :~ rule(mean, ((tax_revenue_percentage(country)), (citizens(country)), (high_economic_freedom(country)), (high_corruption_concern(country)))) with_credibility (min, 0.7).

 %Libertad economica, Esperanza de vida, Percepcion de la corrupcion, Suicidios, Educacion primaria, Tasa de mortalidad infantil, PBI per capita
high_wellbeing_country(country) :~ rule(mean, (high_economic_freedom(country), life_expectancy_rate(country), fnot(high_corruption_concern(country)), fnot(alarming_suicide_rate(country)), (high_education_primary(country)), fnot(infant_mortality_rate(country)), (wealthy_gdp_per_capita(country)))) with_credibility (min, 0.7).

 %Tasa de educación primaria, Tasa de educacion terciaria, Tasa de mortalidad infantil, PBI per capita
good_education_and_future_country(country) :~ rule(mean, (high_education_primary(country), high_education_tertiary(country), fnot(infant_mortality_rate(country)), (wealthy_gdp_per_capita(country)))) with_credibility (min, 0.7).

%Poblacion activa, tasa de desempleo, salario minimo, porcentaje de ingresos fiscales
%Un alto porcentaje puede indicar una mayor capacidad del gobierno para financiar programas de empleo y bienestar social, lo que puede influir en la estabilidad y dinámica del mercado laboral.
strong_labor_market(country) :~ rule(mean, (active_workers(country), fnot(unemployment_rate(country)), min_wage(country), (tax_revenue_percentage(country)))) with_credibility (min, 0.7).


%Ciudadania, tasa de desempleo, ingresos fiscales, PBI per capita
%Este indicador proporciona una medida del nivel de riqueza promedio de los ciudadanos y puede ser útil para evaluar la relación entre la población y la economía.
big_economy(country) :~ rule(mean, (citizens(country), fnot(unemployment_rate(country)), tax_revenue_percentage(country), (wealthy_gdp_per_capita(country)))) with_credibility(min,0.7).