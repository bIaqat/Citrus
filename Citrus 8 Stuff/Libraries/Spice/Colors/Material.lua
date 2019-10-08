--ported from SpiceV2
Citrus.color.fromMaterial = function(name, number, accent)
	local set = accent and {100,200,400,700} or {50,100,200,300,400,500,600,700,800,900}
	local number, key = number or 6
	for i,v in next, set do
		if number == v then
			key = i
		end
	end
	key = key or set[number]
	return Citrus.color:getColor(key, 'Material', accent and 'Accent' or name, not accent and name or nil)
end;


Citrus.color:storeColor('Red',{Color3.fromRGB(255, 235, 238),Color3.fromRGB(255, 205, 210),Color3.fromRGB(239, 154, 154),Color3.fromRGB(229, 115, 115),Color3.fromRGB(239, 83, 80),Color3.fromRGB(244, 67, 54),Color3.fromRGB(229, 57, 53),Color3.fromRGB(211, 47, 47),Color3.fromRGB(198, 40, 40),Color3.fromRGB(183, 28, 28),}, 'Material')
Citrus.color:storeColor('Pink',{Color3.fromRGB(252, 228, 236),Color3.fromRGB(248, 187, 208),Color3.fromRGB(244, 143, 177),Color3.fromRGB(240, 98, 146),Color3.fromRGB(236, 64, 122),Color3.fromRGB(233, 30, 99),Color3.fromRGB(216, 27, 96),Color3.fromRGB(194, 24, 91),Color3.fromRGB(173, 20, 87),Color3.fromRGB(136, 14, 79),}, 'Material')
Citrus.color:storeColor('Purple',{Color3.fromRGB(243, 229, 245),Color3.fromRGB(225, 190, 231),Color3.fromRGB(206, 147, 216),Color3.fromRGB(186, 104, 200),Color3.fromRGB(171, 71, 188),Color3.fromRGB(156, 39, 176),Color3.fromRGB(142, 36, 170),Color3.fromRGB(123, 31, 162),Color3.fromRGB(106, 27, 154),Color3.fromRGB(74, 20, 140),}, 'Material')
Citrus.color:storeColor('Deep purple',{Color3.fromRGB(237, 231, 246),Color3.fromRGB(209, 196, 233),Color3.fromRGB(179, 157, 219),Color3.fromRGB(149, 117, 205),Color3.fromRGB(126, 87, 194),Color3.fromRGB(103, 58, 183),Color3.fromRGB(94, 53, 177),Color3.fromRGB(81, 45, 168),Color3.fromRGB(69, 39, 160),Color3.fromRGB(49, 27, 146),}, 'Material')
Citrus.color:storeColor('Indigo',{Color3.fromRGB(232, 234, 246),Color3.fromRGB(197, 202, 233),Color3.fromRGB(159, 168, 218),Color3.fromRGB(121, 134, 203),Color3.fromRGB(92, 107, 192),Color3.fromRGB(63, 81, 181),Color3.fromRGB(57, 73, 171),Color3.fromRGB(48, 63, 159),Color3.fromRGB(40, 53, 147),Color3.fromRGB(26, 35, 126),}, 'Material')
Citrus.color:storeColor('Blue',{Color3.fromRGB(227, 242, 253),Color3.fromRGB(187, 222, 251),Color3.fromRGB(144, 202, 249),Color3.fromRGB(100, 181, 246),Color3.fromRGB(66, 165, 245),Color3.fromRGB(33, 150, 243),Color3.fromRGB(30, 136, 229),Color3.fromRGB(25, 118, 210),Color3.fromRGB(21, 101, 192),Color3.fromRGB(13, 71, 161),}, 'Material')
Citrus.color:storeColor('Light blue',{Color3.fromRGB(225, 245, 254),Color3.fromRGB(179, 229, 252),Color3.fromRGB(129, 212, 250),Color3.fromRGB(79, 195, 247),Color3.fromRGB(41, 182, 246),Color3.fromRGB(3, 169, 244),Color3.fromRGB(3, 155, 229),Color3.fromRGB(2, 136, 209),Color3.fromRGB(2, 119, 189),Color3.fromRGB(1, 87, 155),}, 'Material')
Citrus.color:storeColor('Cyan',{Color3.fromRGB(224, 247, 250),Color3.fromRGB(178, 235, 242),Color3.fromRGB(128, 222, 234),Color3.fromRGB(77, 208, 225),Color3.fromRGB(38, 198, 218),Color3.fromRGB(0, 188, 212),Color3.fromRGB(0, 172, 193),Color3.fromRGB(0, 151, 167),Color3.fromRGB(0, 131, 143),Color3.fromRGB(0, 96, 100),}, 'Material')
Citrus.color:storeColor('Teal',{Color3.fromRGB(224, 242, 241),Color3.fromRGB(178, 223, 219),Color3.fromRGB(128, 203, 196),Color3.fromRGB(77, 182, 172),Color3.fromRGB(38, 166, 154),Color3.fromRGB(0, 150, 136),Color3.fromRGB(0, 137, 123),Color3.fromRGB(0, 121, 107),Color3.fromRGB(0, 105, 92),Color3.fromRGB(0, 77, 64),}, 'Material')
Citrus.color:storeColor('Green',{Color3.fromRGB(232, 245, 233),Color3.fromRGB(200, 230, 201),Color3.fromRGB(165, 214, 167),Color3.fromRGB(129, 199, 132),Color3.fromRGB(102, 187, 106),Color3.fromRGB(76, 175, 80),Color3.fromRGB(67, 160, 71),Color3.fromRGB(56, 142, 60),Color3.fromRGB(46, 125, 50),Color3.fromRGB(27, 94, 32),}, 'Material')
Citrus.color:storeColor('Light green',{Color3.fromRGB(241, 248, 233),Color3.fromRGB(220, 237, 200),Color3.fromRGB(197, 225, 165),Color3.fromRGB(174, 213, 129),Color3.fromRGB(156, 204, 101),Color3.fromRGB(139, 195, 74),Color3.fromRGB(124, 179, 66),Color3.fromRGB(104, 159, 56),Color3.fromRGB(85, 139, 47),Color3.fromRGB(51, 105, 30),}, 'Material')
Citrus.color:storeColor('Lime',{Color3.fromRGB(249, 251, 231),Color3.fromRGB(240, 244, 195),Color3.fromRGB(230, 238, 156),Color3.fromRGB(220, 231, 117),Color3.fromRGB(212, 225, 87),Color3.fromRGB(205, 220, 57),Color3.fromRGB(192, 202, 51),Color3.fromRGB(175, 180, 43),Color3.fromRGB(158, 157, 36),Color3.fromRGB(130, 119, 23),}, 'Material')
Citrus.color:storeColor('Yellow',{Color3.fromRGB(255, 253, 231),Color3.fromRGB(255, 249, 196),Color3.fromRGB(255, 245, 157),Color3.fromRGB(255, 241, 118),Color3.fromRGB(255, 238, 88),Color3.fromRGB(255, 235, 59),Color3.fromRGB(253, 216, 53),Color3.fromRGB(251, 192, 45),Color3.fromRGB(249, 168, 37),Color3.fromRGB(245, 127, 23),}, 'Material')
Citrus.color:storeColor('Amber',{Color3.fromRGB(255, 248, 225),Color3.fromRGB(255, 236, 179),Color3.fromRGB(255, 224, 130),Color3.fromRGB(255, 213, 79),Color3.fromRGB(255, 202, 40),Color3.fromRGB(255, 193, 7),Color3.fromRGB(255, 179, 0),Color3.fromRGB(255, 160, 0),Color3.fromRGB(255, 143, 0),Color3.fromRGB(255, 111, 0),}, 'Material')
Citrus.color:storeColor('Orange',{Color3.fromRGB(255, 243, 224),Color3.fromRGB(255, 224, 178),Color3.fromRGB(255, 204, 128),Color3.fromRGB(255, 183, 77),Color3.fromRGB(255, 167, 38),Color3.fromRGB(255, 152, 0),Color3.fromRGB(251, 140, 0),Color3.fromRGB(245, 124, 0),Color3.fromRGB(239, 108, 0),Color3.fromRGB(230, 81, 0),}, 'Material')
Citrus.color:storeColor('Deep orange',{Color3.fromRGB(251, 233, 231),Color3.fromRGB(255, 204, 188),Color3.fromRGB(255, 171, 145),Color3.fromRGB(255, 138, 101),Color3.fromRGB(255, 112, 67),Color3.fromRGB(255, 87, 34),Color3.fromRGB(244, 81, 30),Color3.fromRGB(230, 74, 25),Color3.fromRGB(216, 67, 21),Color3.fromRGB(191, 54, 12),}, 'Material')
Citrus.color:storeColor('Brown',{Color3.fromRGB(239, 235, 233),Color3.fromRGB(215, 204, 200),Color3.fromRGB(188, 170, 164),Color3.fromRGB(161, 136, 127),Color3.fromRGB(141, 110, 99),Color3.fromRGB(121, 85, 72),Color3.fromRGB(109, 76, 65),Color3.fromRGB(93, 64, 55),Color3.fromRGB(78, 52, 46),Color3.fromRGB(62, 39, 35),}, 'Material')
Citrus.color:storeColor('Grey',{Color3.fromRGB(250, 250, 250),Color3.fromRGB(245, 245, 245),Color3.fromRGB(238, 238, 238),Color3.fromRGB(224, 224, 224),Color3.fromRGB(189, 189, 189),Color3.fromRGB(158, 158, 158),Color3.fromRGB(117, 117, 117),Color3.fromRGB(97, 97, 97),Color3.fromRGB(66, 66, 66),Color3.fromRGB(33, 33, 33),}, 'Material')
Citrus.color:storeColor('Blue grey',{Color3.fromRGB(236, 239, 241),Color3.fromRGB(207, 216, 220),Color3.fromRGB(176, 190, 197),Color3.fromRGB(144, 164, 174),Color3.fromRGB(120, 144, 156),Color3.fromRGB(96, 125, 139),Color3.fromRGB(84, 110, 122),Color3.fromRGB(69, 90, 100),Color3.fromRGB(55, 71, 79),Color3.fromRGB(38, 50, 56),}, 'Material')
Citrus.color:storeColor('Red',{Color3.fromRGB(255, 138, 128),Color3.fromRGB(255, 82, 82),Color3.fromRGB(255, 23, 68),Color3.fromRGB(213, 0, 0),}, 'Material', 'Accent')
Citrus.color:storeColor('Pink',{Color3.fromRGB(255, 128, 171),Color3.fromRGB(255, 64, 129),Color3.fromRGB(245, 0, 87),Color3.fromRGB(197, 17, 98),}, 'Material', 'Accent')
Citrus.color:storeColor('Purple',{Color3.fromRGB(234, 128, 252),Color3.fromRGB(224, 64, 251),Color3.fromRGB(213, 0, 249),Color3.fromRGB(170, 0, 255),}, 'Material', 'Accent')
Citrus.color:storeColor('Deep purple',{Color3.fromRGB(179, 136, 255),Color3.fromRGB(124, 77, 255),Color3.fromRGB(101, 31, 255),Color3.fromRGB(98, 0, 234),}, 'Material', 'Accent')
Citrus.color:storeColor('Indigo',{Color3.fromRGB(140, 158, 255),Color3.fromRGB(83, 109, 254),Color3.fromRGB(61, 90, 254),Color3.fromRGB(48, 79, 254),}, 'Material', 'Accent')
Citrus.color:storeColor('Blue',{Color3.fromRGB(130, 177, 255),Color3.fromRGB(68, 138, 255),Color3.fromRGB(41, 121, 255),Color3.fromRGB(41, 98, 255),}, 'Material', 'Accent')
Citrus.color:storeColor('Light blue',{Color3.fromRGB(128, 216, 255),Color3.fromRGB(64, 196, 255),Color3.fromRGB(0, 176, 255),Color3.fromRGB(0, 145, 234),}, 'Material', 'Accent')
Citrus.color:storeColor('Cyan',{Color3.fromRGB(132, 255, 255),Color3.fromRGB(24, 255, 255),Color3.fromRGB(0, 229, 255),Color3.fromRGB(0, 184, 212),}, 'Material', 'Accent')
Citrus.color:storeColor('Teal',{Color3.fromRGB(167, 255, 235),Color3.fromRGB(100, 255, 218),Color3.fromRGB(29, 233, 182),Color3.fromRGB(0, 191, 165),}, 'Material', 'Accent')
Citrus.color:storeColor('Green',{Color3.fromRGB(185, 246, 202),Color3.fromRGB(105, 240, 174),Color3.fromRGB(0, 230, 118),Color3.fromRGB(0, 200, 83),}, 'Material', 'Accent')
Citrus.color:storeColor('Light green',{Color3.fromRGB(204, 255, 144),Color3.fromRGB(178, 255, 89),Color3.fromRGB(118, 255, 3),Color3.fromRGB(100, 221, 23),}, 'Material', 'Accent')
Citrus.color:storeColor('Lime',{Color3.fromRGB(244, 255, 129),Color3.fromRGB(238, 255, 65),Color3.fromRGB(198, 255, 0),Color3.fromRGB(174, 234, 0),}, 'Material', 'Accent')
Citrus.color:storeColor('Yellow',{Color3.fromRGB(255, 255, 141),Color3.fromRGB(255, 255, 0),Color3.fromRGB(255, 234, 0),Color3.fromRGB(255, 214, 0),}, 'Material', 'Accent')
Citrus.color:storeColor('Amber',{Color3.fromRGB(255, 229, 127),Color3.fromRGB(255, 215, 64),Color3.fromRGB(255, 196, 0),Color3.fromRGB(255, 171, 0),}, 'Material', 'Accent')
Citrus.color:storeColor('Orange',{Color3.fromRGB(255, 209, 128),Color3.fromRGB(255, 171, 64),Color3.fromRGB(255, 145, 0),Color3.fromRGB(255, 109, 0),}, 'Material', 'Accent')
Citrus.color:storeColor('Deep orange',{Color3.fromRGB(255, 158, 128),Color3.fromRGB(255, 110, 64),Color3.fromRGB(255, 61, 0),Color3.fromRGB(221, 44, 0),}, 'Material', 'Accent')
