local Vec2 = {x = 0.0, y = 0.0};

function Vec2:new(_vec2)
  _vec2 = _vec2 or {};
  setmetatable(_vec2, self);
  self.__index = self;
  return _vec2;
end

function Vec2:Normalize()
  if self:Mag() ~= 0.0 then
    self.x = self.x / self:Mag();
    self.y = self.y / self:Mag();
  end
end

function Vec2:Mag()
  return math.sqrt((self.x * self.x) + (self.y * self.y));
end

function Vec2.__add(_vec1, _vec2)
  output = Vec2:new();
  output.x = _vec1.x + _vec2.x;
  output.y = _vec1.y + _vec2.y;
  return output;
end

function Vec2.__mul(_vec1, _factor)
  output = Vec2:new();
  output.x = _vec1.x * _factor;
  output.y = _vec1.y * _factor;
  return output;
end

return Vec2;
