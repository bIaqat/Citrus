local Misc = {};

function Misc.round(Number, byDecimal)
	local dec = math.pow(10,byDecimal or 0);

	return math.ceil(Number * dec - .5) / dec;
end;

function Misc.destroyIn(Object, howManySeconds)
	game:GetService'Debris':AddItem(Object,howManySeconds);
end;

function Misc.getAssetId(assetId)
	local asset = game:GetService'InsertService':LoadAsset(tonumber(assetId)):GetChildren()[1];
	local className = asset.ClassName

	assetId = asset[className == 'ShirtGraphic' and 'Graphic' or className == 'Shirt' and 'ShirtTemplate' or className == 'Pants' and 'PantsTemplate' or className == 'Decal' and 'Texture'];
	
	return assetId:sub(assetId:find'='+1);
end;

function Misc.getTextSize(String, textSize, font, absoluteSize)
	return game:GetService'TextService':GetTextSize(String or '', textSize or 12, font or Enum.Fonts.SourceSans, absoluteSize or Vector2.new(0,0));
end;

function Misc.getTextSizeFromObject(Object, testObjectProperties)
	local textLabel = Object;

	if testObjectProperties then
		for property, value in next, testObjectProperties do
			textLabel[property] = value;
		end
	end

	return game:GetService'TextService':GetTextSize(Object.Text, Object.FontSize, Object.Font, Object.AbsoluteSize);
end;

function Misc.operation(a,b,op)
	return op == '+' and a + b or
	op == '-' and a - b or
	(op == '*' or op == 'x') and a * b or
	op == '/' and a / b or
	op == '%' and a % b or
	(op == 'pow' or op == '^') and a ^ b or
	(op == 'rt' or op == '^/') and a ^ (1/b);
end;