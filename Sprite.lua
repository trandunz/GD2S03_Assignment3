--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Sprite.lua
--Description : Sprite Implementation File
--Author : Will Inman

local Sprite = {};

-- returns a new sprite instance
function Sprite:new(_sprite)
  _sprite = _sprite or {XPos, YPos, R = 1, G = 1, B = 1, XScale = 0.5, YScale = 0.5, Rotation = 0};
  setmetatable(_sprite, self);
  self.__index = self;
  return _sprite;
end

-- initializes the sprite
function Sprite:Create(_filePath, _xPos, _yPos)
  self.Image = love.graphics.newImage(_filePath);
  self.XPos = _xPos;
  self.YPos = _yPos;
end

-- returns the position of the sprite
function Sprite:GetPosition()
  local pos = require("Vec2"):new();
  pos.x = self.XPos;
  pos.y = self.YPos;
  return pos;
end

-- rotates the sprite by the specified amount
function Sprite:Rotate(_amount)
  self.Rotation = self.Rotation + _amount;
end

-- sets the scale of the sprite
function Sprite:SetScale(_x, _y)
  self.XScale = _x;
  self.YScale = _y;
end

-- sets the colour of the sprite
function Sprite:SetColor(_r, _g, _b)
  self.R = _r / 255;
  self.G = _g / 255;
  self.B = _b / 255
end

-- returns the width of the sprite
function Sprite:GetWidth()
  return self.Image:getWidth();
end

-- returns the height of the sprite
function Sprite:GetHeight()
  return self.Image:getHeight();
end

-- sets the image / texture of the sprite
function Sprite:SetImage(_file)
  self.Image = love.graphics.newImage(_file);
end

-- draws the sprite
function Sprite:Draw()
  love.graphics.setColor( self.R, self.G, self.B );
  love.graphics.draw(self.Image,
  self.XPos,
  self.YPos,
  self.Rotation,
  self.XScale,
  self.YScale,
  self.Image:getWidth()/2,
  self.Image:getHeight()/2);
  love.graphics.setColor( 1, 1, 1 );
end

return Sprite;
