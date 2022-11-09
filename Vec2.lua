--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Vec2.lua
--Description : Vec2 Implementation File
--Author : Will Inman

local Vec2 = {};

-- returns a new vector2 instance
function Vec2:new(_vec2)
  _vec2 = _vec2 or {x = 0.0, y = 0.0};
  setmetatable(_vec2, self);
  self.__index = self;
  return _vec2;
end

-- normalizes the vector
function Vec2:Normalize()
  if self:Mag() ~= 0.0 then
    mag = self:Mag();
    self.x = self.x / mag;
    self.y = self.y / mag;
  end

  return self;
end

-- returns the magnitude of the vector
function Vec2:Mag()
  return math.sqrt((self.x * self.x) + (self.y * self.y));
end

-- overloads the + operator
function Vec2.__add(_vec1, _vec2)
  local output = Vec2:new();
  output.x = _vec1.x + _vec2.x;
  output.y = _vec1.y + _vec2.y;
  return output;
end

-- overloads the - operator
function Vec2.__sub(_vec1, _vec2)
  local output = Vec2:new();
  output.x = _vec1.x - _vec2.x;
  output.y = _vec1.y - _vec2.y;
  return output;
end

-- overloads the * operator
function Vec2.__mul(_vec1, _factor)
  local output = Vec2:new();
  output.x = _vec1.x * _factor;
  output.y = _vec1.y * _factor;
  return output;
end

return Vec2;
