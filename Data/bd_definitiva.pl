 :- module(bd_definitiva ,_, [rfuzzy, clpr]).
define_database(bd_definitiva/30,
[(country_number, rfuzzy_string_type),
(country_name, rfuzzy_string_type),
(libertad economica, rfuzzy_float_type),
(temperatura media superficie (2021), rfuzzy_float_type),
(tasa de suicidios (/100.000hab), rfuzzy_float_type),
(poblacion percibe corrupcion, rfuzzy_float_type),
(density (p/km2), rfuzzy_integer_type),
(agricultural land, rfuzzy_float_type),
(land area(km2), rfuzzy_integer_type),
(armed forces size, rfuzzy_integer_type),
(birth rate, rfuzzy_float_type),
(co2-emissions, rfuzzy_integer_type),
(cpi, rfuzzy_float_type),
(fertility rate, rfuzzy_float_type),
(forested area, rfuzzy_float_type),
(gdp, rfuzzy_integer_type),
(gross primary education enrollment, rfuzzy_float_type),
(gross tertiary education enrollment, rfuzzy_float_type),
(infant mortality, rfuzzy_float_type),
(life expectancy, rfuzzy_float_type),
(population, rfuzzy_integer_type),
(population: labor force participation, rfuzzy_float_type),
(tax revenue , rfuzzy_float_type),
(unemployment rate, rfuzzy_float_type),
(urban_population, rfuzzy_integer_type),
(latitude, rfuzzy_float_type),
(longitude, rfuzzy_float_type),
(renewables, rfuzzy_float_type),
(minimum wage, rfuzzy_integer_type),
(medianage, rfuzzy_integer_type)]).
bd_definitiva(0, Algeria, 4.82, 23.92, 3.6833333333333336, 0.752, 18, 17.40, 2, 381, 741, 317, 000, 24.28, 150, 006, 151.36, 3.02, 0.80, $169, 988, 236, 398 , 109.90, 51.40, 20.1, 76.7, 43, 053, 054, 41.20, 37.20, 11.70, 31, 510, 100, 28.033886, 1.659626, 0.26136735, 2163.0, 29.0).
bd_definitiva(1, Argentina, 4.77, 15.4, 8.7029, 0.834, 17, 54.30, 2, 780, 400, 105, 000, 17.02, 201, 348, 232.75, 2.26, 9.80, $449, 663, 446, 954 , 109.70, 90.00, 8.8, 76.5, 44, 938, 712, 61.30, 10.10, 9.79, 41, 339, 571, -38.416097, -63.616672, 11.329249, 7108.0, 32.0).
bd_definitiva(2, Australia, 8.05, 22.05, 10.650033333333333, 0.442, 3, 48.20, 7, 741, 220, 58, 000, 12.6, 375, 908, 119.8, 1.74, 16.30, $1, 392, 680, 589, 329 , 100.30, 113.10, 3.1, 82.7, 25, 766, 605, 65.50, 23.00, 5.27, 21, 844, 756, -25.274398, 133.775136, 12.933532, 30152.0, 38.0).
bd_definitiva(3, Austria, 7.69, 7.41, 16.539233333333332, 0.481, 109, 32.40, 83, 871, 21, 000, 9.7, 61, 448, 118.06, 1.47, 46.90, $446, 314, 739, 528 , 103.10, 85.10, 2.9, 81.6, 8, 877, 067, 60.70, 25.40, 4.67, 5, 194, 416, 47.516231, 14.550072, 37.481792, 0.0, 43.0).
bd_definitiva(4, Azerbaijan, 5.99, 13.9, 4.733333333333333, 0.506, 123, 57.70, 86, 600, 82, 000, 14.0, 37, 620, 156.32, 1.73, 14.10, $39, 207, 000, 000 , 99.70, 27.70, 19.2, 72.9, 10, 023, 318, 66.50, 13.00, 5.51, 5, 616, 165, 40.143105, 47.576927, 2.2015429, 1744.0, 32.0).
bd_definitiva(5, Bangladesh, 5.81, 25.7, 4.95, 0.682, 1, 265, 70.60, 148, 460, 221, 000, 18.18, 84, 246, 179.68, 2.04, 11.00, $302, 571, 254, 131 , 116.50, 20.60, 25.1, 72.3, 167, 310, 838, 59.00, 8.80, 4.19, 60, 987, 417, 23.684994, 90.356331, 0.6501469, 224.0, 28.0).
bd_definitiva(6, Belarus, 6.23, 7.33, 42.3071, 0.627, 47, 42.00, 207, 600, 155, 000, 9.9, 58, 280, , 1.45, 42.60, $63, 080, 457, 023 , 100.50, 87.40, 2.6, 74.2, 9, 466, 856, 64.10, 14.70, 4.59, 7, 482, 982, 53.709807, 27.953389, 0.9698578, 2052.0, 40.0).
bd_definitiva(7, Belgium, 7.43, 10.48, 20.3469, 0.646, 383, 44.60, 30, 528, 32, 000, 10.3, 96, 889, 117.11, 1.62, 22.60, $529, 606, 710, 418 , 103.90, 79.70, 2.9, 81.6, 11, 484, 055, 53.60, 24.00, 5.59, 11, 259, 082, 50.503887, 4.469936, 9.336409, 22565.0, 42.0).
bd_definitiva(8, Brazil, 6.58, 25.57, 4.69, 0.756, 25, 33.90, 8, 515, 770, 730, 000, 13.92, 462, 299, 167.4, 1.73, 58.90, $1, 839, 758, 040, 766 , 115.40, 51.30, 12.8, 75.7, 212, 559, 417, 63.90, 14.20, 12.08, 183, 241, 641, -14.235004, -51.92528, 46.21975, 3644.0, 33.0).
bd_definitiva(9, Bulgaria, 7.46, 11.97, 13.5062, 0.932, 64, 46.30, 110, 879, 31, 000, 8.9, 41, 708, 114.42, 1.56, 35.40, $86, 000, 000, 000 , 89.30, 71.00, 5.9, 74.9, 6, 975, 761, 55.40, 20.20, 4.34, 5, 256, 027, 42.733883, 25.48583, 11.486526, 4399.0, 45.0).
bd_definitiva(10, Canada, 7.98, -3.7, 11.256866666666667, 0.415, 4, 6.90, 9, 984, 670, 72, 000, 10.1, 544, 894, 116.76, 1.5, 38.20, $1, 736, 425, 629, 520 , 100.90, 68.90, 4.3, 81.9, 36, 991, 981, 65.10, 12.80, 5.56, 30, 628, 482, 56.130366, -106.346771, 29.88844, 21920.0, 41.0).
bd_definitiva(11, Chile, 7.66, 9.81, 10.111733333333333, 0.83, 26, 21.20, 756, 096, 122, 000, 12.43, 85, 822, 131.91, 1.65, 24.30, $282, 318, 159, 745 , 101.40, 88.50, 6.2, 80.0, 18, 952, 038, 62.60, 18.20, 7.09, 16, 610, 135, -35.675147, -71.542969, 26.518875, 6039.0, 35.0).
bd_definitiva(12, Colombia, 6.6, 24.97, 4.17, 0.841, 46, 40.30, 1, 138, 910, 481, 000, 14.88, 97, 814, 140.95, 1.81, 52.70, $323, 802, 808, 108 , 114.50, 55.30, 12.2, 77.1, 50, 339, 443, 68.80, 14.40, 9.71, 40, 827, 302, 4.570868, -74.297333, 33.02041, 4317.0, 31.0).
bd_definitiva(13, Croatia, 7.25, 12.19, 18.463533333333334, 0.939, 73, 27.60, 56, 594, 18, 000, 9.0, 17, 488, 109.82, 1.47, 34.40, $60, 415, 553, 039 , 96.50, 67.90, 4.0, 78.1, 4, 067, 500, 51.20, 22.00, 6.93, 2, 328, 318, 45.1, 15.2, 28.271935, 6798.0, 44.0).
bd_definitiva(14, Denmark, 8.1, 8.96, 14.7494, 0.179, 137, 62.00, 43, 094, 15, 000, 10.6, 31, 786, 110.35, 1.73, 14.70, $348, 078, 018, 464 , 101.30, 80.60, 3.6, 81.0, 5, 818, 553, 62.20, 32.40, 4.91, 5, 119, 978, 56.26392, 9.501785, 39.24958, 0.0, 42.0).
bd_definitiva(15, Ecuador, 6.46, 21.42, 10.012766666666666, 0.843, 71, 22.20, 283, 561, 41, 000, 19.72, 41, 155, 124.14, 2.43, 50.20, $107, 435, 665, 000 , 103.30, 44.90, 12.2, 76.8, 17, 373, 662, 68.00, , 3.97, 11, 116, 711, -1.831239, -78.183406, 32.3542, 5200.0, 28.0).
bd_definitiva(16, Estonia, 7.95, 6.3, 21.471766666666667, 0.527, 31, 23.10, 45, 228, 6, 000, 10.9, 16, 590, 122.14, 1.59, 51.30, $31, 386, 949, 981 , 97.20, 69.60, 2.1, 78.2, 1, 331, 824, 63.60, 20.90, 5.11, 916, 024, 58.595272, 25.013607, 14.325047, 7877.0, 42.0).
bd_definitiva(17, Finland, 7.81, 2.34, 21.181966666666664, 0.186, 18, 7.50, 338, 145, 25, 000, 8.6, 45, 871, 112.33, 1.41, 73.10, $268, 761, 201, 365 , 100.20, 88.20, 1.4, 81.7, 5, 520, 314, 59.10, 20.80, 6.59, 4, 716, 888, 61.92411, 25.748151, 34.61129, 0.0, 43.0).
bd_definitiva(18, France, 7.4, 11.58, 18.630333333333333, 0.571, 119, 52.40, 643, 801, 307, 000, 11.3, 303, 276, 110.05, 1.88, 31.20, $2, 715, 518, 274, 227 , 102.50, 65.60, 3.4, 82.5, 67, 059, 887, 55.10, 24.20, 8.43, 54, 123, 364, 46.227638, 2.213749, 13.671011, 21142.0, 42.0).
bd_definitiva(19, Germany, 7.73, 9.49, 12.860666666666665, 0.46, 240, 47.70, 357, 022, 180, 000, 9.5, 727, 973, 112.85, 1.56, 32.70, $3, 845, 630, 030, 824 , 104.00, 70.20, 3.1, 80.9, 83, 132, 799, 60.80, 11.50, 3.04, 64, 324, 835, 51.165691, 10.451526, 19.453121, 22525.0, 46.0).
bd_definitiva(20, Greece, 6.94, 15.09, 3.6666666666666665, 0.823, 81, 47.60, 131, 957, 146, 000, 8.1, 62, 434, 101.87, 1.35, 31.70, $209, 852, 761, 469 , 99.60, 136.60, 3.6, 81.3, 10, 716, 322, 51.80, 26.20, 17.24, 8, 507, 474, 39.074208, 21.824312, 19.391674, 10731.0, 46.0).
bd_definitiva(21, Hungary, 7.36, 11.58, 25.4199, 0.876, 107, 58.40, 93, 028, 40, 000, 9.6, 45, 537, 121.64, 1.54, 22.90, $160, 967, 157, 504 , 100.80, 48.50, 3.6, 75.8, 9, 769, 949, 56.50, 23.00, 3.40, 6, 999, 582, 47.162494, 19.503304, 6.819573, 7040.0, 43.0).
bd_definitiva(22, Iceland, 7.93, 2.43, 12.447899999999999, 0.673, 3, 18.70, 103, 000, 0, 12.0, 2, 065, 129, 1.71, 0.50, $24, 188, 035, 739 , 100.40, 71.80, 1.5, 82.7, 361, 313, 75.00, 23.30, 2.84, 339, 110, 64.963051, -19.020835, 86.874535, 0.0, 37.0).
bd_definitiva(23, Indonesia, 6.93, 26.01, 2.8966666666666665, 0.867, 151, 31.50, 1, 904, 569, 676, 000, 18.07, 563, 325, 151.18, 2.31, 49.90, $1, 119, 190, 780, 753 , 106.40, 36.30, 21.1, 71.5, 270, 203, 917, 67.50, 10.20, 4.69, 151, 509, 724, -0.789275, 113.921327, 10.385715, 2619.0, 30.0).
bd_definitiva(24, Iraq, 5.49, 24.21, 3.8333333333333335, 0.875, 93, 21.40, 438, 317, 209, 000, 29.08, 190, 061, 119.86, 3.67, 1.90, $234, 094, 042, 939 , 108.70, 16.20, 22.5, 70.5, 39, 309, 783, 43.00, 2.00, 12.82, 27, 783, 368, 33.223191, 43.679291, 1.502491, 2534.0, 21.0).
bd_definitiva(25, Israel, 7.57, 20.86, 5.496666666666667, 0.753, 400, 24.60, 20, 770, 178, 000, 20.8, 65, 166, 108.15, 3.09, 7.70, $395, 098, 666, 122 , 104.90, 63.40, 3.0, 82.8, 9, 053, 300, 64.00, 23.10, 3.86, 8, 374, 393, 31.046051, 34.851612, 5.132294, 17667.0, 30.0).
bd_definitiva(26, Italy, 7.25, 13.52, 6.737133333333333, 0.866, 206, 43.20, 301, 340, 347, 000, 7.3, 320, 411, 110.62, 1.29, 31.80, $2, 001, 244, 392, 042 , 101.90, 61.90, 2.6, 82.9, 60, 297, 396, 49.60, 24.30, 9.89, 42, 651, 966, 41.87194, 12.56738, 18.36226, 0.0, 47.0).
bd_definitiva(27, Japan, 7.79, 12.45, 24.034966666666666, 0.638, 347, 12.30, 377, 944, 261, 000, 7.4, 1, 135, 886, 105.48, 1.42, 68.50, $5, 081, 769, 542, 380 , 98.80, 63.20, 1.8, 84.2, 126, 226, 568, 61.70, 11.90, 2.29, 115, 782, 416, 36.204824, 138.252924, 11.428995, 15112.0, 48.0).
bd_definitiva(28, Kazakhstan, 7.13, 7.83, 38.59753333333333, 0.733, 7, 80.40, 2, 724, 900, 71, 000, 21.77, 247, 207, 182.75, 2.84, 1.20, $180, 161, 741, 180 , 104.40, 61.70, 8.8, 73.2, 18, 513, 930, 68.80, 11.70, 4.59, 10, 652, 915, 48.019573, 66.923684, 3.988574, 1041.0, 31.0).
bd_definitiva(29, Latvia, 7.71, 6.82, 24.1484, 0.8, 30, 31.10, 64, 589, 6, 000, 10.0, 7, 004, 116.86, 1.6, 54.00, $34, 117, 202, 555 , 99.40, 88.10, 3.3, 74.7, 1, 912, 789, 61.40, 22.90, 6.52, 1, 304, 943, 56.879635, 24.603189, 23.917372, 6088.0, 44.0).
bd_definitiva(30, Luxembourg, 7.91, 9.77, 15.267366666666668, 0.386, 242, 53.70, 2, 586, 2, 000, 10.3, 8, 988, 115.09, 1.37, 35.70, $71, 104, 919, 108 , 102.30, 19.20, 1.9, 82.1, 645, 397, 59.30, 26.50, 5.36, 565, 488, 49.815273, 6.129583, 7.095166, 29374.0, 40.0).
bd_definitiva(31, Malaysia, 7.19, 26.47, 4.43, 0.839, 99, 26.30, 329, 847, 136, 000, 16.75, 248, 289, 121.46, 2.0, 67.60, $364, 701, 517, 788 , 105.30, 45.10, 6.7, 76.0, 32, 447, 385, 64.30, 12.00, 3.32, 24, 475, 766, 4.210484, 101.975766, 8.059835, 2566.0, 30.0).
bd_definitiva(32, Mexico, 7.02, 21.85, 4.05, 0.799, 66, 54.60, 1, 964, 375, 336, 000, 17.6, 486, 406, 141.54, 2.13, 33.90, $1, 258, 286, 717, 125 , 105.80, 40.20, 11.0, 75.0, 126, 014, 024, 60.70, 13.10, 3.42, 102, 626, 859, 23.634501, -102.552784, 10.514754, 2725.0, 29.0).
bd_definitiva(33, New Zealand, 8.43, 11.18, 13.171566666666665, 0.242, 18, 40.50, 268, 838, 9, 000, 11.98, 34, 382, 114.24, 1.71, 38.60, $206, 928, 765, 544 , 100.00, 82.00, 4.7, 81.9, 4, 841, 000, 69.90, 29.00, 4.07, 4, 258, 860, -40.900557, 174.885971, 40.21865, 27881.0, 38.0).
bd_definitiva(34, Norway, 7.67, 2.11, 12.782033333333333, 0.27, 15, 2.70, 323, 802, 23, 000, 10.4, 41, 023, 120.27, 1.56, 33.20, $403, 336, 363, 636 , 100.30, 82.00, 2.1, 82.8, 5, 347, 896, 63.80, 23.90, 3.35, 4, 418, 218, 60.472024, 8.468946, 71.558365, 0.0, 40.0).
bd_definitiva(35, Pakistan, 5.98, 22.03, 9.094499999999998, 0.787, 287, 47.80, 796, 095, 936, 000, 28.25, 201, 150, 182.32, 3.51, 1.90, $304, 400, 000, 000 , 94.30, 9.00, 57.2, 67.1, 216, 565, 318, 52.60, 9.20, 4.45, 79, 927, 762, 30.375321, 69.345116, 10.622897, 1724.0, 23.0).
bd_definitiva(36, Peru, 7.52, 19.79, 2.6933333333333334, 0.891, 26, 18.50, 1, 285, 216, 158, 000, 17.95, 57, 414, 129.78, 2.25, 57.70, $226, 848, 050, 820 , 106.90, 70.70, 11.1, 76.5, 32, 510, 453, 77.60, 14.30, 3.31, 25, 390, 339, -9.189967, -75.015152, 27.741009, 3423.0, 31.0).
bd_definitiva(37, Philippines, 7.01, 26.7, 1.978, 0.742, 368, 41.70, 300, 000, 153, 000, 20.55, 122, 287, 129.61, 2.58, 27.80, $376, 795, 508, 680 , 107.50, 35.50, 22.5, 71.1, 108, 116, 615, 59.60, 14.00, 2.15, 50, 975, 903, 12.879721, 121.774017, 10.90163, 2770.0, 26.0).
bd_definitiva(38, Poland, 7.12, 8.75, 17.33693333333333, 0.735, 124, 46.90, 312, 685, 191, 000, 10.2, 299, 037, 114.11, 1.46, 30.90, $592, 164, 400, 688 , 100.00, 67.80, 3.8, 77.6, 37, 970, 874, 56.70, 17.40, 3.47, 22, 796, 574, 51.919438, 19.145136, 7.7616863, 8254.0, 42.0).
bd_definitiva(39, Portugal, 7.54, 16.1, 11.639066666666666, 0.887, 111, 39.50, 92, 212, 52, 000, 8.5, 48, 742, 110.62, 1.38, 34.60, $237, 686, 075, 635 , 106.20, 63.90, 3.1, 81.3, 10, 269, 417, 58.80, 22.80, 6.33, 6, 753, 579, 39.399872, -8.224454, 32.703953, 9910.0, 46.0).
bd_definitiva(40, Romania, 7.7, 10.35, 13.058933333333334, 0.938, 84, 58.80, 238, 391, 126, 000, 9.6, 69, 259, 123.78, 1.71, 30.10, $250, 077, 444, 017 , 85.20, 49.40, 6.1, 75.4, 19, 356, 544, 54.70, 14.60, 3.98, 10, 468, 793, 45.943161, 24.96676, 17.481031, 6163.0, 43.0).
bd_definitiva(41, Slovenia, 7.23, 10.0, 28.1514, 0.806, 103, 30.70, 20, 273, 7, 000, 9.4, 12, 633, 111.05, 1.6, 62.00, $53, 742, 159, 517 , 100.40, 78.60, 1.7, 81.0, 2, 087, 946, 58.40, 18.60, 4.20, 1, 144, 654, 46.151241, 14.995463, 18.768454, 12553.0, 45.0).
bd_definitiva(42, South Africa, 6.53, 18.06, 23.712533333333337, 0.86, 49, 79.80, 1, 219, 090, 80, 000, 20.51, 476, 644, 158.93, 2.41, 7.60, $351, 431, 649, 241 , 100.90, 22.40, 28.5, 63.9, 58, 558, 270, 56.00, 27.50, 28.18, 39, 149, 717, -30.559482, 22.937506, 3.408608, 3511.0, 28.0).
bd_definitiva(43, Spain, 7.52, 14.31, 7.536466666666667, 0.745, 94, 52.60, 505, 370, 196, 000, 7.9, 244, 002, 110.96, 1.26, 36.90, $1, 394, 116, 310, 769 , 102.70, 88.90, 2.5, 83.3, 47, 076, 781, 57.50, 14.20, 13.96, 37, 927, 409, 40.463667, -3.74922, 22.341663, 15687.0, 45.0).
bd_definitiva(44, Sri Lanka, 6.13, 27.4, 18.3899, 0.863, 341, 43.70, 65, 610, 317, 000, 15.83, 23, 362, 155.53, 2.2, 32.90, $84, 008, 783, 756 , 100.20, 19.60, 6.4, 76.8, 21, 803, 000, 53.90, 11.90, 4.20, 4, 052, 088, 7.873054, 80.771797, 21.404533, 787.0, 34.0).
bd_definitiva(45, Sweden, 7.81, 3.08, 15.012533333333332, 0.237, 25, 7.40, 450, 295, 30, 000, 11.4, 43, 252, 110.51, 1.76, 68.90, $530, 832, 908, 738 , 126.60, 67.00, 2.2, 82.5, 10, 285, 453, 64.60, 27.90, 6.48, 9, 021, 165, 60.128161, 18.643501, 50.924007, 0.0, 41.0).
bd_definitiva(46, Switzerland, 8.47, 6.39, 18.9183, 0.292, 219, 38.40, 41, 277, 21, 000, 10.0, 34, 477, 99.55, 1.52, 31.80, $703, 082, 435, 360 , 105.20, 59.60, 3.7, 83.6, 8, 574, 832, 68.30, 10.10, 4.58, 6, 332, 428, 46.818188, 8.227512, 36.716644, 34284.0, 43.0).
bd_definitiva(47, Thailand, 7.07, 26.9, 8.929766666666666, 0.895, 137, 43.30, 513, 120, 455, 000, 10.34, 283, 763, 113.27, 1.53, 32.20, $543, 649, 976, 166 , 99.80, 49.30, 7.8, 76.9, 69, 625, 582, 67.30, 14.90, 0.75, 35, 294, 600, 15.870032, 100.992541, 7.113618, 3034.0, 40.0).
bd_definitiva(48, Ukraine, 6.17, 9.37, 31.930233333333334, 0.924, 75, 71.70, 603, 550, 297, 000, 8.7, 202, 250, 281.66, 1.3, 16.70, $153, 781, 069, 118 , 99.00, 82.70, 7.5, 71.6, 44, 385, 155, 54.20, 20.10, 8.88, 30, 835, 699, 48.379433, 31.16558, 6.1008415, 2131.0, 41.0).

