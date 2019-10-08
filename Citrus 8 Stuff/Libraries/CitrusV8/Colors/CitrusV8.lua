local baseColor = Citrus.color.fromHex'2EB7E8'
local citrusv8 = {}
local names = {'blue', 'deep blue', 'deep purple', 'purple', 'magenta', 'rose', 'red', 'orange', 'yellow', 'lime', 'green', 'green', 'mint', 'cyan', 'light blue'};

for i = 1, 15 do
    --baseColor = Citrus.Beta.color:editHSV(baseColor,'+',360/15,0,0)
    local h,s,v = Color3.toHSV(baseColor)
    h = (h*360 + 24) % 360 / 360
    baseColor = Color3.fromHSV(h, s, v)
    table.insert(citrusv8,baseColor)
end

for i,v in next, citrusv8 do
    local name = names[i];
    Citrus.color:storeColor(4, v, 'citrusv8', name);
    local l,d = Citrus.color.getTints(v,4), Citrus.color.getShades(v,4)
    for y = 2, 4 do
        Citrus.color:storeColor(4-y+1, l[y], 'citrusv8', name)
        Citrus.color:storeColor(y+3, d[y], 'citrusv8', name)
    end
end