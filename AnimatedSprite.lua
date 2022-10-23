local AnimatedSprite = {};
local anim8 = require("anim8/anim8");

function AnimatedSprite:new(_animatedSprite)
  _animatedSprite = _animatedSprite or {XPos, YPos, XScale = 1, YScale = 1, R = 1, G = 1, B = 1, Grid, Animations = {}, xFrameSize, yFrameSize, NumerOfAnimations = 0, CurrentAnimation = 0};
  setmetatable(_animatedSprite, self);
  self.__index = self;
  return _animatedSprite;
end

function AnimatedSprite:Create(_filePath, _xPos, _yPos, _xFrameSize, _yFrameSize)
  self.Image = love.graphics.newImage(_filePath);
  self.XPos = _xPos;
  self.YPos = _yPos;
  self.xFrameSize = _xFrameSize;
  self.yFrameSize = _yFrameSize;
  self.Grid = anim8.newGrid(self.xFrameSize, self.yFrameSize, self.Image:getWidth(), self.Image:getHeight())
end

function AnimatedSprite:AddAnimation(_frameRange, _frameDuration)
  self.NumerOfAnimations = self.NumerOfAnimations + 1;
  self.Animations[self.NumerOfAnimations] = anim8.newAnimation(self.Grid(_frameRange,1), _frameDuration)
end

function AnimatedSprite:SetColor(_r, _g, _b)
  self.R = _r / 255;
  self.G = _g / 255;
  self.B = _b / 255
end

function AnimatedSprite:GetWidth()
  return self.Image:getWidth();
end

function AnimatedSprite:SetScale(_x, _y)
  self.XScale = _x;
  self.YScale = _y;
end

function AnimatedSprite:GetHeight()
  return self.Image:getHeight();
end

function AnimatedSprite:Update(_dt)
  for i=1, self.NumerOfAnimations do
    if self.CurrentAnimation ~= i then
      self.Animations[i]:gotoFrame(1)
    end
  end

  self.Animations[self.CurrentAnimation]:update(_dt);
end

function AnimatedSprite:Draw()
  love.graphics.setColor( self.R, self.G, self.B );
  self.Animations[self.CurrentAnimation]:draw(self.Image, self.XPos, self.YPos, 0, self.XScale,self.YScale,self.xFrameSize/2, self.yFrameSize/2);
  love.graphics.setColor( 1, 1, 1 );
end

return AnimatedSprite;
