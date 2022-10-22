local RigidBody = {World, body, fixture, shape, position = require("Vec2"):new(), Density = 1, sizeX = 0, sizeY = 0, offsetX = 0, offsetY = 0};

function RigidBody:new(_rigidBody)
  _rigidBody = _rigidBody or {};
  setmetatable(_rigidBody, self);
  self.__index = self;
  return _rigidBody;
end

function RigidBody:SetWorld(_world)
  self.World = _world;
end

function RigidBody:Create(_xPos, _yPos, _shape, _bodyType, _userData)
 self.body = love.physics.newBody(self.World, _xPos, _yPos, _bodyType);
 self.fixture = love.physics.newFixture(self.body, _shape, 0.0);
 self.fixture:setUserData(_userData);
 self.Density = self.fixture.density;
end

function RigidBody:CreateCube(_xPos, _yPos, _xSize, _ySize, _bodyType, _angle, _userData)
  self.body = love.physics.newBody(self.World, _xPos , _yPos , _bodyType);
  self.shape = love.physics.newRectangleShape(0,0,_xSize, _ySize,_angle);
  self.fixture = love.physics.newFixture(self.body, self.shape, 1);
  self.fixture:setUserData(_userData);
  self.Density = self.fixture.density;
  self.sizeX = _xSize;
  self.sizeY = _ySize;
end

function RigidBody:SetSize(_x, _y, _xOffset, _yOffset)
  self.shape = love.physics.newRectangleShape(_xOffset,_yOffset,_x, _y,0);
end

function RigidBody:ResetSize()
   self.shape = love.physics.newRectangleShape(self.offsetX,self.offsetY,self.sizeX, self.sizeY,0);
end

function RigidBody:SetDensity(_density)
  self.fixture:setDensity(_density);
end

function RigidBody:ResetDensity()
  self.fixture:setDensity(self.Density);
end

function RigidBody:SetFixedToRotation(_fixedRotation)
  self.body:setFixedRotation(_fixedRotation);
end

function RigidBody:ApplyLinearImpulse(_x, _y)
  self.body:applyLinearImpulse(_x, _y);
end

function RigidBody:GetVelocity()
  local velocity = require("Vec2"):new();
  velocity.x, velocity.y = self.body:getLinearVelocity();
  return velocity;
end

function RigidBody:GetXSpeed()
  local velocity = require("Vec2"):new();
  velocity.x, velocity.y = self.body:getLinearVelocity();
  return math.sqrt(velocity.x * velocity.x);
end

function RigidBody:GetYSpeed()
  local velocity = require("Vec2"):new();
  velocity.x, velocity.y = self.body:getLinearVelocity();
  return math.sqrt(velocity.y * velocity.y);
end

function RigidBody:GetPosition()
  self.position.x = self.body:getX();
  self.position.y = self.body:getY();
  return self.position;
end

function RigidBody:Draw()
  love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end

function RigidBody:SetVelocity(_xVelocity, _yVelocity)
  self.body:setLinearVelocity(_xVelocity,_yVelocity);
end

return RigidBody;
