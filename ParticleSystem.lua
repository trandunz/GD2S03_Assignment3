--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : ParticleSystem.lua
--Description : ParticleSystem Implementation File
--Author : Will Inman

local ParticleSystem = {};

-- returns a new instance of a particle system
function ParticleSystem:new(_particleSystem)
  _particleSystem = _particleSystem or {System, Canvas, Image, xPos, yPos};
  setmetatable(_particleSystem, self);
  self.__index = self;
  return _particleSystem;
end

-- Initializes the particle syste,
function ParticleSystem:Create(_image, _maxParticles, _xPos, _yPos)
  self.Image = _image;
  self.xPos = _xPos;
  self.yPos = _yPos;

  local img = love.graphics.newImage(_image);
  local ps = love.graphics.newParticleSystem(img, _maxParticles);
  ps:setParticleLifetime(0.25);
  ps:setEmissionArea("uniform", 10, 0);
  self.System = ps;
  self.System:setPosition(_xPos, _yPos);
  self.System:setColors(255, 255, 255, 255, 255, 255, 255, 0)
end

-- sets the texture of the particle system
function ParticleSystem:SetTexture(_texture)
  local img = love.graphics.newImage(_texture);
  self.System:setTexture(img);
end

-- sets the emission posiion of the particle system
function ParticleSystem:SetPosition(_x, _y)
  self.xPos = _x;
  self.yPos = _y;
  self.System:setPosition(_x, _y);
end

-- plays the particle system
function ParticleSystem:Play()
  self.System:start();
end

-- Emit the specified number of particles from the specified position
function ParticleSystem:Emit(_amount, _pos)
  _amount = _amount or 1;
  if _pos then
    self.xPos = _pos.x;
    self.yPos = _pos.y;
  end
  self.System:setPosition(self.xPos, self.yPos);
  self.System:emit(_amount)
end

-- pause the paticle system
function ParticleSystem:Pause()
  self.System:pause();
end

-- stop the particle system
function ParticleSystem:Stop()
  self.System:stop();
end

-- updates the particle system
function ParticleSystem:Update(_dt)
  self.System:update(_dt);
end

-- draw the particle system
function ParticleSystem:Draw()
  love.graphics.draw(self.System, 0,0);
end

return ParticleSystem;
