RigidBody = {body, fixture, shape};

World = require("World");

function RigidBody:new(_rigidBody)
  _rigidBody = {body, fixture, shape};
  setmetatable(self, _rigidBody);
  assert(getmetatable(self) == _rigidBody);
  self.__index = self;
  return self;
end

function RigidBody:Create(_xPos, _yPos, _shape, _bodyType)
 self.body = love.physics.newBody(world, _xPos, _yPos, _bodyType);
 self.fixture = love.physics.newFixture(self.body, _shape, 0.0);
end

function RigidBody:CreateCube(_xPos, _yPos, _xSize, _ySize, _bodyType)
  self.body = love.physics.newBody(world, _xPos , _yPos , _bodyType);
  self.shape = love.physics.newRectangleShape(0,0, _xSize, _ySize);
  self.fixture = love.physics.newFixture(self.body, self.shape, 1);
end

function RigidBody:GetPosition()
  position = require("Vec2"):new();
  position.x = self.body:getX();
  position.y = self.body:getY();
  return position;
end

function RigidBody:Move(_xAmount,_yAmount)
  self.body:setLinearVelocity(_xAmount,_yAmount);
end

return RigidBody;
