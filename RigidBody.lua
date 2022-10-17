RigidBody = {World, body, fixture, shape, position = require("Vec2"):new()};

function RigidBody:new(_rigidBody)
  _rigidBody = _rigidBody or {};
  setmetatable(_rigidBody, self);
  self.__index = self;
  return _rigidBody;
end

function RigidBody:SetWorld(_world)
  self.World = _world;
end

function RigidBody:Create(_xPos, _yPos, _shape, _bodyType)
 self.body = love.physics.newBody(self.World, _xPos, _yPos, _bodyType);
 self.fixture = love.physics.newFixture(self.body, _shape, 0.0);
end

function RigidBody:CreateCube(_xPos, _yPos, _xSize, _ySize, _bodyType, _angle)
  self.body = love.physics.newBody(self.World, _xPos , _yPos , _bodyType);
  self.shape = love.physics.newRectangleShape(0,0,_xSize, _ySize,_angle);
  self.fixture = love.physics.newFixture(self.body, self.shape, 1);
end

function RigidBody:SetFixedToRotation(_fixedRotation)
  self.body:setFixedRotation(_fixedRotation);
end

function RigidBody:ApplyLinearImpulse(_x, _y)
  self.body:applyLinearImpulse(_x, _y);
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
