Vec2 = {x = 0.0, y = 0.0};

function Vec2:new(_vec2)
  _vec2 = {x = 0.0, y = 0.0};
  setmetatable(self, _vec2);
  assert(getmetatable(self) == _vec2);
  self.__index = self;
  return self;
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

return Vec2;
