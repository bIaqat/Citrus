local function obc(t, b, c, d)
  t = t / d
  if t < 1 / 2.75 then
    return c * (7.5625 * t * t) + b
  elseif t < 2 / 2.75 then
    t = t - (1.5 / 2.75)
    return c * (7.5625 * t * t + 0.75) + b
  elseif t < 2.5 / 2.75 then
    t = t - (2.25 / 2.75)
    return c * (7.5625 * t * t + 0.9375) + b
  else
    t = t - (2.625 / 2.75)
    return c * (7.5625 * t * t + 0.984375) + b
  end
end
local Basics = {
  Linear = {
    Out = function(t, b, c, d)
      return c * t / d + b
    end;
  };
  Quad = {
    In = function(t, b, c, d)
        t = t / d
        return c * math.pow(t, 2) + b
    end;
    Out = function(t, b, c, d)
      t = t / d
      return -c * t * (t - 2) + b
    end;
    InOut = function(t, b, c, d)
      t = t / d * 2
      if t < 1 then
        return c / 2 * math.pow(t, 2) + b
      else
        return -c / 2 * ((t - 1) * (t - 3) - 1) + b
      end
    end;
  };
  Cubic = {
    In = function(t, b, c, d)
      t = t / d
      return c * math.pow(t, 3) + b
    end;
    Out = function(t, b, c, d)
      t = t / d - 1
      return c * (math.pow(t, 3) + 1) + b
    end;
    InOut = function(t, b, c, d)
      t = t / d * 2
      if t < 1 then
        return c / 2 * t * t * t + b
      else
        t = t - 2
        return c / 2 * (t * t * t + 2) + b
      end
    end;
  };
  Quart = {
    In = function(t, b, c, d)
      t = t / d
      return c * math.pow(t, 4) + b
    end;
    Out = function(t, b, c, d)
      t = t / d - 1
      return -c * (math.pow(t, 4) - 1) + b
    end;
    InOut = function(t, b, c, d)
      t = t / d * 2
      if t < 1 then
        return c / 2 * math.pow(t, 4) + b
      else
        t = t - 2
        return -c / 2 * (math.pow(t, 4) - 2) + b
      end
    end;
  };
  Quint = {
    In = function(t, b, c, d)
      t = t / d
      return c * math.pow(t, 5) + b
    end;
    Out = function(t, b, c, d)
      t = t / d - 1
      return c * (math.pow(t, 5) + 1) + b
    end;
    InOut = function(t, b, c, d)
      t = t / d * 2
      if t < 1 then
        return c / 2 * math.pow(t, 5) + b
      else
        t = t - 2
        return c / 2 * (math.pow(t, 5) + 2) + b
      end
    end;
  };
  Sine = {
    In = function(t, b, c, d)
      return -c * math.cos(t / d * (math.pi / 2)) + c + b
    end;
    Out = function(t, b, c, d)
      return c * math.sin(t / d * (math.pi / 2)) + b
    end;
    InOut = function(t, b, c, d)
      return -c / 2 * (math.cos(math.pi * t / d) - 1) + b
    end;
  };
  Expo = {
    In = function(t, b, c, d)
      if t == 0 then
        return b
      else
        return c * math.pow(2, 10 * (t / d - 1)) + b - c * 0.001
      end
    end;
    Out = function(t, b, c, d)
      if t == d then
        return b + c
      else
        return c * 1.001 * (-math.pow(2, -10 * t / d) + 1) + b
      end
    end;
    InOut = function(t, b, c, d)
      if t == 0 then return b end
      if t == d then return b + c end
      t = t / d * 2
      if t < 1 then
        return c / 2 * math.pow(2, 10 * (t - 1)) + b - c * 0.0005
      else
        t = t - 1
        return c / 2 * 1.0005 * (-math.pow(2, -10 * t) + 2) + b
      end
    end;
  };
  Circular = {
    In = function(t, b, c, d)
      t = t / d
      return(-c * (math.sqrt(1 - math.pow(t, 2)) - 1) + b)
    end;
    Out = function(t, b, c, d)
      t = t / d - 1
      return(c * math.sqrt(1 - math.pow(t, 2)) + b)
    end;
    InOut = function(t, b, c, d)
      t = t / d * 2
      if t < 1 then
        return -c / 2 * (math.sqrt(1 - t * t) - 1) + b
      else
        t = t - 2
        return c / 2 * (math.sqrt(1 - t * t) + 1) + b
      end
    end;
  };
  Elastic = {
    In = function(t, b, c, d)
      if t == 0 then return b end
      t = t / d
      if t == 1  then return b + c end
      local s, a, p
      p = d * 0.3
      a = c
      s = p / 4
      t = t - 1
      return -(a * math.pow(2, 10 * t) * math.sin((t * d - s) * (2 * math.pi) / p)) + b
    end;
    Out = function(t, b, c, d)
      if t == 0 then return b end

      t = t / d

      if t == 1 then return b + c end
      local s,a,p
      p = d * 0.3
      a = c
      s = p / 4
      return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p) + c + b
    end;
    InOut = function(t, b, c, d)
      if t == 0 then return b end

      t = t / d * 2

      if t == 2 then return b + c end
      local s, a, p
      p = d * (0.3 * 1.5)
      a = 0

      if not a or a < math.abs(c) then
        a = c
        s = p / 4
      else
        s = p / (2 * math.pi) * math.asin(c / a)
      end

      if t < 1 then
        t = t - 1
        return -0.5 * (a * math.pow(2, 10 * t) * math.sin((t * d - s) * (2 * math.pi) / p)) + b
      else
        t = t - 1
        return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p ) * 0.5 + c + b
      end
    end;
  };
  Back = {
    In = function(t, b, c, d)
      local s = 1.70158
      t = t / d
      return c * t * t * ((s + 1) * t - s) + b
    end;
    Out = function(t, b, c, d)
      local s = 1.70158
      t = t / d - 1
      return c * (t * t * ((s + 1) * t + s) + 1) + b
    end;
    InOut = function(t, b, c, d)
      local s = 1.70158 * 1.525
      t = t / d * 2
      if t < 1 then
        return c / 2 * (t * t * ((s + 1) * t - s)) + b
      else
        t = t - 2
        return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
      end
    end;
  };
  Bounce = {
    Out = obc;
    In = function(t, b, c, d)
      return c - obc(d - t, 0, c, d) + b
    end;
    InOut = function(t, b, c, d)
      if t < d / 2 then
        local ibc = c - obc(d - (t * 2), 0, c, d) + b
        return ibc * 0.5 + b
      else
        return obc(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
      end
    end;
    OutIn = function(t, b, c, d)
      if t < d / 2 then
        return obc(t * 2, b, c / 2, d)
      else
        local t,b,c,d = (t * 2) - d, b + c / 2, c / 2, d
        return c - obc(d - t, 0, c, d) + b
      end
    end;
  };
}

for i,v in next, Basics do
  Spice.Motion.Easings.newStyle(i, v)
end