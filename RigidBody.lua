--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : RigidBody.lua
--Description : RigidBody Implementation File
--Author : Will Inman

local RigidBody = {};

function RigidBody:new(_rigidBody)
  _rigidBody = _rigidBody or {World, body, fixture, shape, position = require("Vec2"):new(), Density = 1, sizeX = 0, sizeY = 0, offsetX = 0, offsetY = 0};
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

function RigidBody:GetWorld()
  if self.body ~= nil then
    return self.body:getWorld();
  end
end

function RigidBody:CreateCube(_xPos, _yPos, _xSize, _ySize, _bodyType, _angle, _userDataFixture, _xOffset, _yOffset, _sensor, _userDataBody)
  _xOffset = _xOffset or 0;
  _yOffset = _yOffset or 0;
  _sensor = _sensor or false;

  self.body = love.physics.newBody(self.World, _xPos , _yPos , _bodyType);
  self.shape = love.physics.newRectangleShape(_xOffset,_yOffset,_xSize, _ySize,_angle);
  self.fixture = love.physics.newFixture(self.body, self.shape, 1);
  self.fixture:setUserData(_userDataFixture);
  self.body:setUserData(_userDataBody);
  self.Density = self.fixture.density;
  self.fixture:setSensor(_sensor);
  self.fixture:setFriction( 0 );
  self.sizeX = _xSize;
  self.sizeY = _ySize;
  self.offsetX = _xOffset;
  self.offsetY = _yOffset;
end

function RigidBody:SetSize(_x, _y, _xOffset, _yOffset)
  if self.body ~= nil then
    self.shape = love.physics.newRectangleShape(_xOffset,_yOffset,_x, _y,0);
  end
end

function RigidBody:ResetSize()
  if self.body ~= nil then
    self.shape = love.physics.newRectangleShape(self.offsetX,self.offsetY,self.sizeX, self.sizeY,0);
  end
end

function RigidBody:Destroy()
  if self.body ~= nil then
    self.body:destroy();
  end
end

function RigidBody:SetRotation(_radians)
  if self.body ~= nil then
    self.body:setAngle(_radians);
  end
end

function RigidBody:SetGravity(_scale)
  if self.body ~= nil then
    self.body:setGravityScale(_scale);
  end
end

function RigidBody:SetDensity(_density)
  if self.body ~= nil then
    self.fixture:setDensity(_density);
  end
end

function RigidBody:GetCenter()
  if self.body ~= nil then
    local center = require("Vec2"):new();
    center.x, center.y = self.body:getWorldCenter();
    return center;
  end
end

function RigidBody:ResetDensity()
  if self.body ~= nil then
    self.fixture:setDensity(self.Density);
  end
end

function RigidBody:SetFixedToRotation(_fixedRotation)
  if self.body ~= nil then
    self.body:setFixedRotation(_fixedRotation);
  end
end

function RigidBody:ApplyLinearImpulse(_x, _y)
  if self.body ~= nil then
    self.body:applyLinearImpulse(_x, _y);
  end
end

function RigidBody:GetVelocity()
  if self.body ~= nil then
    local velocity = require("Vec2"):new();
    velocity.x, velocity.y = self.body:getLinearVelocity();
    return velocity;
  end
end

function RigidBody:GetXSpeed()
  if self.body ~= nil then
    local velocity = require("Vec2"):new();
    velocity.x, velocity.y = self.body:getLinearVelocity();
    return math.sqrt(velocity.x * velocity.x);
  end
end

function RigidBody:GetYSpeed()
  if self.body ~= nil then
    local velocity = require("Vec2"):new();
    velocity.x, velocity.y = self.body:getLinearVelocity();
    return math.sqrt(velocity.y * velocity.y);
  end
end

function RigidBody:ToggleCollision(_collisionEnabled)
  if self.fixture ~= nil then
    self.fixture:setSensor(not _collisionEnabled);
  end
end

function RigidBody:GetPosition()
  if self.body ~= nil then
    self.position.x = self.body:getX();
    self.position.y = self.body:getY();
    return self.position;
  end
end

function RigidBody:Draw()
  if self.body ~= nil and DebugDraw == true then
    love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
  end
end

function RigidBody:SetVelocity(_xVelocity, _yVelocity)
  if self.body ~= nil then
    self.body:setLinearVelocity(_xVelocity,_yVelocity);
  end
end

return RigidBody;
