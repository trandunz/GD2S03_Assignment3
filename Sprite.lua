local Sprite = {};

function Sprite:new(_sprite)
  _sprite = _sprite or {XPos, YPos, R = 1, G = 1, B = 1, XScale = 0.5, YScale = 0.5};
  setmetatable(_sprite, self);
  self.__index = self;
  return _sprite;
end

function Sprite:Create(_filePath, _xPos, _yPos)
  self.Image = love.graphics.newImage(_filePath);
  self.XPos = _xPos;
  self.YPos = _yPos;
end

function Sprite:GetPosition()
  local pos = require("Vec2"):new();
  pos.x = self.XPos;
  pos.y = self.YPos;
  return pos;
end

function Sprite:SetScale(_x, _y)
  self.XScale = _x;
  self.YScale = _y;
end

function Sprite:SetColor(_r, _g, _b)
  self.R = _r / 255;
  self.G = _g / 255;
  self.B = _b / 255
end

function Sprite:GetWidth()
  return self.Image:getWidth();
end

function Sprite:GetHeight()
  return self.Image:getHeight();
end

function Sprite:SetImage(_file)
  self.Image = love.graphics.newImage(_file);
end

function Sprite:Draw()
  love.graphics.setColor( self.R, self.G, self.B );
  love.graphics.draw(self.Image,
  self.XPos,
  self.YPos,
  0,
  self.XScale,
  self.YScale,
  self.Image:getWidth()/2,
  self.Image:getHeight()/2);
  love.graphics.setColor( 1, 1, 1 );
end

return Sprite;
