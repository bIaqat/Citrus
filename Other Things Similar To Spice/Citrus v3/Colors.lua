local lush = require(script.Parent)
f = lush.Color.Colours
c = lush.Color.new
h = lush.Color.fromHex
hsv = lush.Color.fromHSV
f:insertNewColor('Red',{
	Material = {
		[0] = h'#ffebee';
		{h'#ffcdd2',h'#ff8a80'};
		{h'#ef9a9a',h'#ff5252'};
		h'#e57373';
		{h'#ef5350',h'#ff1744'};
		h'#f44336';
		h'#e53935';
		{h'#d32f2f',h'#d50000'};
		h'#c62828';
		h'#b71c1c';
	}
}
)
f:insertNewColor('Pink',{
	Material = {
		[0] = h'#FCE4EC';
		{h'#F8BBD0',h'#FF80AB'};
		{h'#F48FB1',h'#FF4081'};
		h'#F06292';
		{h'#E91E63',h'#F50057'};
		h'#EC407A';
		h'#D81B60';
		{h'#C2185B',h'#C51162'};
		h'#AD1457';
		h'#880E4F';
	}
}
)
f:insertNewColor('Purple',{
	Material = {
		[0] = h'#F3E5F5';
		{h'#E1BEE7',h'#EA80FC'};
		{h'#CE93D8',h'#E040FB'};
		h'#BA68C8';
		{h'#AB47BC',h'#D500F9'};
		h'#9C27B0';
		h'#8E24AA';
		{h'#7B1FA2',h'#AA00FF'};
		h'#6A1B9A';
		h'#4A148C';
		Deep = {
			[0] = h'#EDE7F6';
			{h'#D1C4E9',h'#B388FF'};
			{h'#B39DDB',h'#7C4DFF'};
			h'#9575CD';
			{h'#7E57C2',h'#651FFF'};
			h'#673AB7';
			h'#5E35B1';
			{h'#512DA8',h'#6200EA'};
			h'#4527A0';
			h'#311B92';			
		}
	}
}
)

f:insertNewColor('Grey',{
	Default = {
		Light = {
			[0] = hsv(0,0,98);
			[1] = hsv(0,0,96);
			[2] = hsv(0,0,87);
			[3] = hsv(0,0,80)			
		};
		Blue = {
			[0] = hsv(219,21,36);
			[1] = hsv(219,25,34);
			[2] = hsv(220,25,27);
			[3] = hsv(218,25,21)		
		};
		Dark = {
			[0] = hsv(0,0,25);
			[1] = hsv(0,0,21);
			[2] = hsv(0,0,12);
			[3] = hsv(0,0,2);	
		};
		[0] = hsv(220,10,32);
		[1] = hsv(213,12,27);
		[2] = hsv(217,12,24);
		[3] = hsv(220,12,18);		
	};
})

f:insertNewColor('Themes',{
	Default = {
		Dark = {
			c('Grey',3),c('Grey',2),c('Grey',1),c('Grey',0);
			Grey = {c('Grey',3,'Dark'),c('Grey',2,'Dark'),c('Grey',1,'Dark'),c('Grey',0,'Dark')};
			Blue = {c('Grey',3,'Blue'),c('Grey',2,'Blue'),c('Grey',1,'Blue'),c('Grey',0,'Blue')};
		};
		Light = {
			c('Grey',0,'Light'),c('Grey',1,'Light'),c('Grey',2,'Light'),c('Grey',3,'Light')
		};
	};
})

return lush