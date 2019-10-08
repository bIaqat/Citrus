function Citrus.Beta.color:editHSV(Color, operation, newH, newS, newV)
	local op = Citrus.misc.operation;
	local h,s,v = self.toHSV(Color)

	return self.fromHSV(op(h,newH,operation)%360, op(s,newS,operation), op(v,newV,operation));
end;