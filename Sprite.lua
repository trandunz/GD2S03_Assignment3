local Sprite = {XPos, YPos, R = 1, G = 1, B = 1};

function Sprite:new(_sprite)
  _sprite = _sprite or {};
  setmetatable(_sprite, self);
  self.__index = self;
  return _sprite;
end

function Sprite:Create(_filePath, _xPos, _yPos)
  self.Image = love.graphics.newImage(_filePath);
  self.XPos = _xPos;
  self.YPos = _yPos;
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

function Sprite:Draw()
  love.graphics.setColor( self.R, self.G, self.B );
  love.graphics.draw(self.Image,
  self.XPos,
  self.YPos,
  0,
  0.5,
  0.5,
  self.Image:getWidth()/2,
  self.Image:getHeight()/2);
  love.graphics.setColor( 1, 1, 1 );
end

return Sprite;
