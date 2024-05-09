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

country(0, 'Algeria', 4.82, 23.92, 3.6833333333333336, 0.752, 18.0, 17.40, 2381741.0, 317000.0, 24.28, 150006.0, 151.36, 3.02, 0.80, 169988236398.0, 109.90, 51.40, 20.1, 76.7, 43053054.0, 41.20, 37.20, 11.70, 31510100.0, 28.033886, 1.659626, 0.26136735, 2163.0, 29.0).
country(1, 'Argentina', 4.77, 15.4, 8.7029, 0.834, 17.0, 54.30, 2780400.0, 105000.0, 17.02, 201348.0, 232.75, 2.26, 9.80, 449663446954.0, 109.70, 90.00, 8.8, 76.5, 44938712.0, 61.30, 10.10, 9.79, 41339571.0, -38.416097, -63.616672, 11.329249, 7108.0, 32.0).
country(2, 'Australia', 8.05, 22.05, 10.650033333333331, 0.442, 3.0, 48.20, 7741220.0, 58000.0, 12.6, 375908.0, 119.8, 1.74, 16.30, 1392680589329.0, 100.30, 113.10, 3.1, 82.7, 25766605.0, 65.50, 23.00, 5.27, 21844756.0, -25.274398, 133.775136, 12.933532, 30152.0, 38.0).
country(3, 'Austria', 7.69, 7.41, 16.539233333333332, 0.481, 109.0, 32.40, 83871.0, 21000.0, 9.7, 61448.0, 118.06, 1.47, 46.90, 446314739528.0, 103.10, 85.10, 2.9, 81.6, 8877067.0, 60.70, 25.40, 4.67, 5194416.0, 47.516231, 14.550072, 37.481792, 0.0, 43.0).
country(4, 'Azerbaijan', 5.99, 13.9, 4.733333333333333, 0.506, 123.0, 57.70, 86600.0, 82000.0, 14.0, 37620.0, 156.32, 1.73, 14.10, 39207000000.0, 99.70, 27.70, 19.2, 72.9, 10023318.0, 66.50, 13.00, 5.51, 5616165.0, 40.143105, 47.576927, 2.2015429, 1744.0, 32.0).
country(5, 'Bangladesh', 5.81, 25.7, 4.95, 0.682, 1265.0, 70.60, 148460.0, 221000.0, 18.18, 84246.0, 179.68, 2.04, 11.00, 302571254131.0, 116.50, 20.60, 25.1, 72.3, 167310838.0, 59.00, 8.80, 4.19, 60987417.0, 23.684994, 90.356331, 0.6501469, 224.0, 28.0).
country(6, 'Belarus', 6.23, 7.33, 42.3071, 0.627, 47.0, 42.00, 207600.0, 155000.0, 9.9, 58280.0, 0.0, 1.45, 42.60, 63080457023.0, 100.50, 87.40, 2.6, 74.2, 9466856.0, 64.10, 14.70, 4.59, 7482982.0, 53.709807, 27.953389, 0.9698578, 2052.0, 40.0).
country(7, 'Belgium', 7.43, 10.48, 20.3469, 0.646, 383.0, 44.60, 30528.0, 32000.0, 10.3, 96889.0, 117.11, 1.62, 22.60, 529606710418.0, 103.90, 79.70, 2.9, 81.6, 11484055.0, 53.60, 24.00, 5.59, 11259082.0, 50.503887, 4.469936, 9.336409, 22565.0, 42.0).
country(8, 'Brazil', 6.58, 25.57, 4.69, 0.756, 25.0, 33.90, 8515770.0, 730000.0, 13.92, 462299.0, 167.4, 1.73, 58.90, 1839758040766.0, 115.40, 51.30, 12.8, 75.7, 212559417.0, 63.90, 14.20, 12.08, 183241641.0, -14.235004, -51.92528, 46.21975, 3644.0, 33.0).
country(9, 'Bulgaria', 7.46, 11.97, 13.5062, 0.932, 64.0, 46.30, 110879.0, 31000.0, 8.9, 41708.0, 114.42, 1.56, 35.40, 86000000000.0, 89.30, 71.00, 5.9, 74.9, 6975761.0, 55.40, 20.20, 4.34, 5256027.0, 42.733883, 25.48583, 11.486526, 4399.0, 45.0).
country(10, 'Canada', 7.98, -3.7, 11.256866666666667, 0.415, 4.0, 6.90, 9984670.0, 72000.0, 10.1, 544894.0, 116.76, 1.5, 38.20, 1736425629520.0, 100.90, 68.90, 4.3, 81.9, 36991981.0, 65.10, 12.80, 5.56, 30628482.0, 56.130366, -106.346771, 29.88844, 21920.0, 41.0).
country(11, 'Chile', 7.66, 9.81, 10.111733333333332, 0.83, 26.0, 21.20, 756096.0, 122000.0, 12.43, 85822.0, 131.91, 1.65, 24.30, 282318159745.0, 101.40, 88.50, 6.2, 80.0, 18952038.0, 62.60, 18.20, 7.09, 16610135.0, -35.675147, -71.542969, 26.518875, 6039.0, 35.0).
country(12, 'Colombia', 6.6, 24.97, 4.17, 0.841, 46.0, 40.30, 1138910.0, 481000.0, 14.88, 97814.0, 140.95, 1.81, 52.70, 323802808108.0, 114.50, 55.30, 12.2, 77.1, 50339443.0, 68.80, 14.40, 9.71, 40827302.0, 4.570868, -74.297333, 33.02041, 4317.0, 31.0).
country(13, 'Croatia', 7.25, 12.19, 18.46353333333333, 0.939, 73.0, 27.60, 56594.0, 18000.0, 9.0, 17488.0, 109.82, 1.47, 34.40, 60415553039.0, 96.50, 67.90, 4.0, 78.1, 4067500.0, 51.20, 22.00, 6.93, 2328318.0, 45.1, 15.2, 28.271935, 6798.0, 44.0).
country(14, 'Denmark', 8.1, 8.96, 14.7494, 0.179, 137.0, 62.00, 43094.0, 15000.0, 10.6, 31786.0, 110.35, 1.73, 14.70, 348078018464.0, 101.30, 80.60, 3.6, 81.0, 5818553.0, 62.20, 32.40, 4.91, 5119978.0, 56.26392, 9.501785, 39.24958, 0.0, 42.0).
country(15, 'Ecuador', 6.46, 21.42, 10.012766666666666, 0.843, 71.0, 22.20, 283561.0, 41000.0, 19.72, 41155.0, 124.14, 2.43, 50.20, 107435665000.0, 103.30, 44.90, 12.2, 76.8, 17373662.0, 68.00, 22.00, 3.97, 11116711.0, -1.831239, -78.183406, 32.3542, 5200.0, 28.0).
country(16, 'Estonia', 7.95, 6.3, 21.471766666666667, 0.527, 31.0, 23.10, 45228.0, 6000.0, 10.9, 16590.0, 122.14, 1.59, 51.30, 31386949981.0, 97.20, 69.60, 2.1, 78.2, 1331824.0, 63.60, 20.90, 5.11, 916024.0, 58.595272, 25.013607, 14.325047, 7877.0, 42.0).
country(17, 'Finland', 7.81, 2.34, 21.181966666666664, 0.186, 18.0, 7.50, 338145.0, 25000.0, 8.6, 45871.0, 112.33, 1.41, 73.10, 268761201365.0, 100.20, 88.20, 1.4, 81.7, 5520314.0, 59.10, 20.80, 6.59, 4716888.0, 61.92411, 25.748151, 34.61129, 0.0, 43.0).
country(18, 'France', 7.4, 11.58, 18.630333333333333, 0.571, 119.0, 52.40, 643801.0, 307000.0, 11.3, 303276.0, 110.05, 1.88, 31.20, 2715518274227.0, 102.50, 65.60, 3.4, 82.5, 67059887.0, 55.10, 24.20, 8.43, 54123364.0, 46.227638, 2.213749, 13.671011, 21142.0, 42.0).
country(19, 'Germany', 7.73, 9.49, 12.860666666666663, 0.46, 240.0, 47.70, 357022.0, 180000.0, 9.5, 727973.0, 112.85, 1.56, 32.70, 3845630030824.0, 104.00, 70.20, 3.1, 80.9, 83132799.0, 60.80, 11.50, 3.04, 64324835.0, 51.165691, 10.451526, 19.453121, 22525.0, 46.0).
country(20, 'Greece', 6.94, 15.09, 3.6666666666666665, 0.823, 81.0, 47.60, 131957.0, 146000.0, 8.1, 62434.0, 101.87, 1.35, 31.70, 209852761469.0, 99.60, 136.60, 3.6, 81.3, 10716322.0, 51.80, 26.20, 17.24, 8507474.0, 39.074208, 21.824312, 19.391674, 10731.0, 46.0).
country(21, 'Hungary', 7.36, 11.58, 25.4199, 0.876, 107.0, 58.40, 93028.0, 40000.0, 9.6, 45537.0, 121.64, 1.54, 22.90, 160967157504.0, 100.80, 48.50, 3.6, 75.8, 9769949.0, 56.50, 23.00, 3.40, 6999582.0, 47.162494, 19.503304, 6.819573, 7040.0, 43.0).
country(22, 'Iceland', 7.93, 2.43, 12.4479, 0.673, 3.0, 18.70, 103000.0, 0.0, 12.0, 2065.0, 129.0, 1.71, 0.50, 24188035739.0, 100.40, 71.80, 1.5, 82.7, 361313.0, 75.00, 23.30, 2.84, 339110.0, 64.963051, -19.020835, 86.874535, 0.0, 37.0).
country(23, 'Indonesia', 6.93, 26.01, 2.8966666666666665, 0.867, 151.0, 31.50, 1904569.0, 676000.0, 18.07, 563325.0, 151.18, 2.31, 49.90, 1119190780753.0, 106.40, 36.30, 21.1, 71.5, 270203917.0, 67.50, 10.20, 4.69, 151509724.0, -0.789275, 113.921327, 10.385715, 2619.0, 30.0).
country(24, 'Iraq', 5.49, 24.21, 3.8333333333333335, 0.875, 93.0, 21.40, 438317.0, 209000.0, 29.08, 190061.0, 119.86, 3.67, 1.90, 234094042939.0, 108.70, 16.20, 22.5, 70.5, 39309783.0, 43.00, 2.00, 12.82, 27783368.0, 33.223191, 43.679291, 1.502491, 2534.0, 21.0).
country(25, 'Israel', 7.57, 20.86, 5.496666666666667, 0.753, 400.0, 24.60, 20770.0, 178000.0, 20.8, 65166.0, 108.15, 3.09, 7.70, 395098666122.0, 104.90, 63.40, 3.0, 82.8, 9053300.0, 64.00, 23.10, 3.86, 8374393.0, 31.046051, 34.851612, 5.132294, 17667.0, 30.0).
country(26, 'Italy', 7.25, 13.52, 6.737133333333333, 0.866, 206.0, 43.20, 301340.0, 347000.0, 7.3, 320411.0, 110.62, 1.29, 31.80, 2001244392042.0, 101.90, 61.90, 2.6, 82.9, 60297396.0, 49.60, 24.30, 9.89, 42651966.0, 41.87194, 12.56738, 18.36226, 0.0, 47.0).
country(27, 'Japan', 7.79, 12.45, 24.034966666666666, 0.638, 347.0, 12.30, 377944.0, 261000.0, 7.4, 1135886.0, 105.48, 1.42, 68.50, 5081769542380.0, 98.80, 63.20, 1.8, 84.2, 126226568.0, 61.70, 11.90, 2.29, 115782416.0, 36.204824, 138.252924, 11.428995, 15112.0, 48.0).
country(28, 'Kazakhstan', 7.13, 7.83, 38.59753333333333, 0.733, 7.0, 80.40, 2724900.0, 71000.0, 21.77, 247207.0, 182.75, 2.84, 1.20, 180161741180.0, 104.40, 61.70, 8.8, 73.2, 18513930.0, 68.80, 11.70, 4.59, 10652915.0, 48.019573, 66.923684, 3.988574, 1041.0, 31.0).
country(29, 'Latvia', 7.71, 6.82, 24.1484, 0.8, 30.0, 31.10, 64589.0, 6000.0, 10.0, 7004.0, 116.86, 1.6, 54.00, 34117202555.0, 99.40, 88.10, 3.3, 74.7, 1912789.0, 61.40, 22.90, 6.52, 1304943.0, 56.879635, 24.603189, 23.917372, 6088.0, 44.0).
country(30, 'Luxembourg', 7.91, 9.77, 15.267366666666668, 0.386, 242.0, 53.70, 2586.0, 2000.0, 10.3, 8988.0, 115.09, 1.37, 35.70, 71104919108.0, 102.30, 19.20, 1.9, 82.1, 645397.0, 59.30, 26.50, 5.36, 565488.0, 49.815273, 6.129583, 7.095166, 29374.0, 40.0).
country(31, 'Malaysia', 7.19, 26.47, 4.43, 0.839, 99.0, 26.30, 329847.0, 136000.0, 16.75, 248289.0, 121.46, 2.0, 67.60, 364701517788.0, 105.30, 45.10, 6.7, 76.0, 32447385.0, 64.30, 12.00, 3.32, 24475766.0, 4.210484, 101.975766, 8.059835, 2566.0, 30.0).
country(32, 'Mexico', 7.02, 21.85, 4.05, 0.799, 66.0, 54.60, 1964375.0, 336000.0, 17.6, 486406.0, 141.54, 2.13, 33.90, 1258286717125.0, 105.80, 40.20, 11.0, 75.0, 126014024.0, 60.70, 13.10, 3.42, 102626859.0, 23.634501, -102.552784, 10.514754, 2725.0, 29.0).
country(33, 'New Zealand', 8.43, 11.18, 13.171566666666664, 0.242, 18.0, 40.50, 268838.0, 9000.0, 11.98, 34382.0, 114.24, 1.71, 38.60, 206928765544.0, 100.00, 82.00, 4.7, 81.9, 4841000.0, 69.90, 29.00, 4.07, 4258860.0, -40.900557, 174.885971, 40.21865, 27881.0, 38.0).
country(34, 'Norway', 7.67, 2.11, 12.782033333333333, 0.27, 15.0, 2.70, 323802.0, 23000.0, 10.4, 41023.0, 120.27, 1.56, 33.20, 403336363636.0, 100.30, 82.00, 2.1, 82.8, 5347896.0, 63.80, 23.90, 3.35, 4418218.0, 60.472024, 8.468946, 71.558365, 0.0, 40.0).
country(35, 'Pakistan', 5.98, 22.03, 9.094499999999998, 0.787, 287.0, 47.80, 796095.0, 936000.0, 28.25, 201150.0, 182.32, 3.51, 1.90, 304400000000.0, 94.30, 9.00, 57.2, 67.1, 216565318.0, 52.60, 9.20, 4.45, 79927762.0, 30.375321, 69.345116, 10.622897, 1724.0, 23.0).
country(36, 'Peru', 7.52, 19.79, 2.6933333333333334, 0.891, 26.0, 18.50, 1285216.0, 158000.0, 17.95, 57414.0, 129.78, 2.25, 57.70, 226848050820.0, 106.90, 70.70, 11.1, 76.5, 32510453.0, 77.60, 14.30, 3.31, 25390339.0, -9.189967, -75.015152, 27.741009, 3423.0, 31.0).
country(37, 'Philippines', 7.01, 26.7, 1.978, 0.742, 368.0, 41.70, 300000.0, 153000.0, 20.55, 122287.0, 129.61, 2.58, 27.80, 376795508680.0, 107.50, 35.50, 22.5, 71.1, 108116615.0, 59.60, 14.00, 2.15, 50975903.0, 12.879721, 121.774017, 10.90163, 2770.0, 26.0).
country(38, 'Poland', 7.12, 8.75, 17.33693333333333, 0.735, 124.0, 46.90, 312685.0, 191000.0, 10.2, 299037.0, 114.11, 1.46, 30.90, 592164400688.0, 100.00, 67.80, 3.8, 77.6, 37970874.0, 56.70, 17.40, 3.47, 22796574.0, 51.919438, 19.145136, 7.7616863, 8254.0, 42.0).
country(39, 'Portugal', 7.54, 16.1, 11.639066666666666, 0.887, 111.0, 39.50, 92212.0, 52000.0, 8.5, 48742.0, 110.62, 1.38, 34.60, 237686075635.0, 106.20, 63.90, 3.1, 81.3, 10269417.0, 58.80, 22.80, 6.33, 6753579.0, 39.399872, -8.224454, 32.703953, 9910.0, 46.0).
country(40, 'Romania', 7.7, 10.35, 13.058933333333334, 0.938, 84.0, 58.80, 238391.0, 126000.0, 9.6, 69259.0, 123.78, 1.71, 30.10, 250077444017.0, 85.20, 49.40, 6.1, 75.4, 19356544.0, 54.70, 14.60, 3.98, 10468793.0, 45.943161, 24.96676, 17.481031, 6163.0, 43.0).
country(41, 'Slovenia', 7.23, 10.0, 28.1514, 0.806, 103.0, 30.70, 20273.0, 7000.0, 9.4, 12633.0, 111.05, 1.6, 62.00, 53742159517.0, 100.40, 78.60, 1.7, 81.0, 2087946.0, 58.40, 18.60, 4.20, 1144654.0, 46.151241, 14.995463, 18.768454, 12553.0, 45.0).
country(42, 'South Africa', 6.53, 18.06, 23.712533333333337, 0.86, 49.0, 79.80, 1219090.0, 80000.0, 20.51, 476644.0, 158.93, 2.41, 7.60, 351431649241.0, 100.90, 22.40, 28.5, 63.9, 58558270.0, 56.00, 27.50, 28.18, 39149717.0, -30.559482, 22.937506, 3.408608, 3511.0, 28.0).
country(43, 'Spain', 7.52, 14.31, 7.536466666666667, 0.745, 94.0, 52.60, 505370.0, 196000.0, 7.9, 244002.0, 110.96, 1.26, 36.90, 1394116310769.0, 102.70, 88.90, 2.5, 83.3, 47076781.0, 57.50, 14.20, 13.96, 37927409.0, 40.463667, -3.74922, 22.341663, 15687.0, 45.0).
country(44, 'Sri Lanka', 6.13, 27.4, 18.3899, 0.863, 341.0, 43.70, 65610.0, 317000.0, 15.83, 23362.0, 155.53, 2.2, 32.90, 84008783756.0, 100.20, 19.60, 6.4, 76.8, 21803000.0, 53.90, 11.90, 4.20, 4052088.0, 7.873054, 80.771797, 21.404533, 787.0, 34.0).
country(45, 'Sweden', 7.81, 3.08, 15.012533333333332, 0.237, 25.0, 7.40, 450295.0, 30000.0, 11.4, 43252.0, 110.51, 1.76, 68.90, 530832908738.0, 126.60, 67.00, 2.2, 82.5, 10285453.0, 64.60, 27.90, 6.48, 9021165.0, 60.128161, 18.643501, 50.924007, 0.0, 41.0).
country(46, 'Switzerland', 8.47, 6.39, 18.9183, 0.292, 219.0, 38.40, 41277.0, 21000.0, 10.0, 34477.0, 99.55, 1.52, 31.80, 703082435360.0, 105.20, 59.60, 3.7, 83.6, 8574832.0, 68.30, 10.10, 4.58, 6332428.0, 46.818188, 8.227512, 36.716644, 34284.0, 43.0).
country(47, 'Thailand', 7.07, 26.9, 8.929766666666666, 0.895, 137.0, 43.30, 513120.0, 455000.0, 10.34, 283763.0, 113.27, 1.53, 32.20, 543649976166.0, 99.80, 49.30, 7.8, 76.9, 69625582.0, 67.30, 14.90, 0.75, 35294600.0, 15.870032, 100.992541, 7.113618, 3034.0, 40.0).
country(48, 'Ukraine', 6.17, 9.37, 31.930233333333334, 0.924, 75.0, 71.70, 603550.0, 297000.0, 8.7, 202250.0, 281.66, 1.3, 16.70, 153781069118.0, 99.00, 82.70, 7.5, 71.6, 44385155.0, 54.20, 20.10, 8.88, 30835699.0, 48.379433, 31.16558, 6.1008415, 2131.0, 41.0).


%%%%%%%%%%%% FUZZY FUNCTIONS %%%%%%%%%%%%%%%

% Economic freedom index
economic_freedom(country) :~ function(economic_freedom_index(country), [(4,0),(5,0.2),(6,0.4),(7,0.6),(8,0.8),(9,1)]).

% Surface temperature
temperature(country) :~ function(surface_temperature(country), [(2,0),(28,1)]).

% Suicide rate
suicide_rate(country) :~ function(suicides(country), [(2,0),(35,1)]).

% People Perceive Corruption
corruption_concern(country) :~ function(people_percive_corruption(country), [(0.2,0),(0.9,1)]).

% Population density (Personas por km^2)
density(country) :~ function(population_density(country), [(10,0),(30,0.2),(80,0.4),(150,0.6),(200,0.8),(600,1)]).

% Agricultural Land (Percentage) //RULE W/ TEMPERATURE
agricultural_land_percentage(country) :~ function(agricultural_land(country), [(5,0),(80,1)]).

% Land Area
surface(country) :~ function(land_area(country), [(50000,0),(9000000,1)]).

% Armed Force Size
armed_forces_rate(country) :~ function(armed_forces_size(country), [(10000,0),(700000,1)]).

% Birth rate
birth_rate(country) :~ function(birth(country), [(7,0),(25,0)]).

% C02 emissions
co2(country) :~ function(co2_emissions(country), [(2000,0),(50000,0.2),(100000,0.4),(200000,0.6),(300000,0.8),(400000,1)]).

% cpi
cpi_rate(country) :~ function(cpi(country), [(25,0), (50,0.2), (75,0.4), (100,0.6), (125,0.8), (150,1)]).

% fertility_rate
fertility_rate(country) :~ function(fertility(country), [(0.5,0), (1,0.2), (1.5,0.4), (2,0.6), (2.5,0.8), (3,1)]).

% forested_area
woodland(country) :~ function(forested_area(country), [(0,0), (11, 0.2), (22, 0.4), (33, 0.6), (44, 0.8), (55, 1)]).

%GDP 
gdp_per_capita(country) :~ function(gdp(country), [(100000000000,0), (200000000000,0.2), (300000000000,0.4), (400000000000,0.6), (500000000000,0.8), (750000000000,1)]).

%Gross primary education errollment (Percentage)
%Enrollment indicators are based on annual school surveys, but do not necessarily reflect actual attendance or dropout rates during the year. Also, the length of education differs
%across countries and can influence enrollment rates, although the International Standard Classification of Education (ISCED) tries to minimize the difference. 
%For example, a shorter duration for primary education tends to increase the rate; a longer one to decrease it (in part because older 
%children are more at risk of dropping out). Moreover, age at enrollment may be inaccurately estimated or misstated, especially in communities where registration of births is not strictly enforced.

education_primary(country) :~ function(gross_primary_education_enrollment(country), [(70,0), (80,0.2), (90,0.4), (95,0.6), (100,0.8), (105,1)]).

%Gross Tertiary Education Enrollment (Percentage)

education_tertiary(country) :~ function(gross_tertiary_education_enrollment(country), [(10,0), (20,0.2), (30,0.4), (40,0.6), (50,0.8), (60,1)]).

%Infant mortality
infant_mortality_rate(country) :~ function(infant_mortality(country), [(2,0), (5,0.2), (10,0.4), (15,0.6), (20,0.8), (25,1)]).

%Life expectancy
life_expectancy_rate(country) :~ function(life_expectancy(country), [(55,0), (60,0.2), (65,0.4), (70,0.6), (75,0.8), (80,1)]).

%Population
citizens(country) :~ function(population(country), [(2000000,0), (10000000,0.2), (20000000,0.4), (30000000,0.6), (40000000,0.8), (50000000,1)]).

 %Población activa (porcentaje)
active_workers(country) :~ function(labor_force(country), [(40,0),(45,0.2),(55,0.4),(65,0.6),(75,0.8),(80,1)]).

 %Tax revenue: porcentaje del PIB
tax_revenue_percentage(country) :~ function(tax_revenue(country), [(5,0),(10,0.2),(15,0.4),(20,0.6),(25,0.8),(30,1)]).

 %Unemployment rate
unemployment_rate(country) :~ function(unemployment(country), [(1,0),(3,0.2),(5,0.4),(7,0.6),(9,0.8),(11,1)]).

 %Urban population TODO: Estan los valores totales, obtener porcentajes y actualizar base de datos
urban_pop(country) :~ function(urban_population(country), [(10,0),(30,0.2),(50,0.4),(70,0.6),(80,0.8),(90,1)]).

 %Latitude y longitud
 %Creo que no tiene sentido una funcion difusa (no hay mucho o poco, etc) Ademas hay valores negativos

 %Renewables (porcentaje del total de energía)
renewable_energy(country) :~ function(renewables(country), [(1,0),(3,0.2),(10,0.4),(18,0.6),(35,0.8),(85,1)]).

 %Minimum wage (en dólares)
min_wage(country) :~ function(minimum_wage(country), [(1000,0.2),(5000,0.4),(10000,0.6),(20000,0.8),(25000,1)]).

 %Median age
mid_age(country) :~ function(median_age(country), [(20,0),(25,0.2),(30,0.4),(35,0.6),(40,0.8),(45,1)]).



 %%%%%%%%%% RULES %%%%%%%%%%  

 %Clean country: relation between renewable energy and urban population
clean_country(country) :~ rule(min, (very(renewable_energy(country)), little(urban_pop(country)))) with_credibility (min, 0.7).

 %Developed country: relation between GDP per capita and life expectancy (I'd add more variables)
developed_country(country) :~ rule(min, (very(gdp_per_capita(country)), very(life_expectancy_rate(country)))) with_credibility (min, 0.7).

 %Strong labor market: relation between minimum wage and unemployment rate, and more...
strong_labor_market(country) :~ rule(min, (very(min_wage(country)), very_little(unemployment_rate(country)), very(active_workers(country)))) with_credibility (min, 0.7).


 %TODO: Ver si tienen sentido y que credibilidad ponerles
political_stable(country) :~ rule(min, (very(economic_freedom(country)), very_little(corruption_concern(country)))) with_credibility (min, 0.7).

environmentally_friendly_country(country) :~ rule(min, (very(renewable_energy(country)), very_little(co2(country)))) with_credibility (min, 0.7).

high_quality_of_life_country(country) :~ rule(min, (very(life_expectancy_rate(country)), very_little(suicide_rate(country)))) with_credibility (min, 0.7).

strong_education_system(country) :~ rule(min, (very(education_primary(country)), very(education_tertiary(country)), very_little(unemployment_rate(country)))) with_credibility (min, 0.7).

high_population_growth_country(country) :~ rule(min, (very(birth_rate(country)), very(fertility_rate(country)))) with_credibility (min, 0.7).

urbanized_country(country) :~ rule(min, (very(urban_pop(country)), very_little(agricultural_land_percentage(country)))) with_credibility (min, 0.7).

militarily_strong_country(country) :~ rule(min, (very(armed_forces_rate(country)), very_little(density(country)))) with_credibility (min, 0.7).

economically_stable_country(country) :~ rule(min, (very(cpi_rate(country)), very_little(unemployment_rate(country)))) with_credibility (min, 0.7).

high_income_country(country) :~ rule(min, (very(gdp_per_capita(country)), very(min_wage(country)))) with_credibility (min, 0.7).

aging_population_country(country) :~ rule(min, (very(mid_age(country)), very_little(birth_rate(country)))) with_credibility (min, 0.7).

quality_healthcare_country(country) :~ rule(min, (very(infant_mortality_rate(country)), very_little(life_expectancy_rate(country)))) with_credibility (min, 0.7).

developed_infrastucture_country(country) :~ rule(min, (very(gdp_per_capita(country)), very_little(surface(country)))) with_credibility (min, 0.7).

sustainable_country(country) :~ rule(min, (very(woodland(country)), very_little(co2(country)))) with_credibility (min, 0.7).

attractive_tourism_destination(country) :~ rule(min, (very(temperature(country)), very_little(woodland(country)))) with_credibility (min, 0.7).

economically_resilient_country(country) :~ rule(min, (very(gdp_per_capita(country)), very_little(cpi_rate(country)))) with_credibility (min, 0.7).

socially_connected_country(country) :~ rule(min, (very(urban_pop(country)), very_little(density(country)))) with_credibility (min, 0.7).

active_civic_participation(country) :~ rule(min, (very(tax_revenue_percentage(country)), very_little(citizens(country)))) with_credibility (min, 0.7).

 %Libertad economica, esperanza de vida, percepcion de la corrupcion, suicidios
national_wellbeing_index(country) :~ rule(min, (economic_freedom(country), life_expectancy_rate(country), corruption_concern(country), suicide_rate(country))) with_credibility (min, 0.7).

 %Tamaño de la tierra agrícola, emisiones de CO2, porcentaje de energias renovables
environmental_sostenibility(country) :~ rule(min, (agricultural_land_percentage(country), co2(country), renewable_energy(country))) with_credibility (min, 0.7).

 %PIB, densidad de poblacion, fuerza laboral, indice de fertilidad
economic_development_potential(country) :~ rule(min, (gdp_per_capita(country), density(country), active_workers(country), fertility_rate(country))) with_credibility (min, 0.7).

 %Densidad de poblacion, desempleo, salario minimo, edad media
urban_life_quality(country) :~ rule(min, (density(country), unemployment_rate(country), min_wage(country), mid_age(country))) with_credibility (min, 0.7).

 %Ingreso fiscal en relacion al PIB, tasa de desempleo, tamaño de las fuerzas armadas
economic_resilience(country) :~ rule(min, (gdp_per_capita(country), unemployment_rate(country), armed_forces_rate(country))) with_credibility (min, 0.7).

 %Matricula en educacion primaria y terciaria, tasa de mortalidad infantil
education_and_future(country) :~ rule(min, (education_primary(country), education_tertiary(country), infant_mortality_rate(country))) with_credibility (min, 0.7).

 %Superficie de tierra agricola, poblacion, emisiones de CO2, superficie total de tierra
local_and_global_agricultural_impact(country) :~ rule(min, (agricultural_land_percentage(country), citizens(country), co2(country), surface(country))) with_credibility (min, 0.7).
