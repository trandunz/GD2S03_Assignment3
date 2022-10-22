local World = {world};
require("CollisionCallbacks");

function World:new(_world)
  _world = _world or {};
  setmetatable(_world, self);
  self.__index = self;
  return _world;
end

function World:InitWorld()
  love.physics.setMeter(64);
  self.world = love.physics.newWorld(0, 40 * love.physics.getMeter() , true);
  self.world:setCallbacks(BeginContact, EndContact, PreSolve, PostSolve);
end

function World:Update(_dt)
  self.world:update(_dt);
end

return World;
