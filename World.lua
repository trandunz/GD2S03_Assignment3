--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : World.lua
--Description : World Implementation File
--Author : Will Inman

local World = {};
require("CollisionCallbacks");

-- returns a new world instance
function World:new(_world)
  _world = _world or {world};
  setmetatable(_world, self);
  self.__index = self;
  return _world;
end

-- initializes the world
function World:InitWorld()
  love.physics.setMeter(64);
  self.world = love.physics.newWorld(0, 40 * love.physics.getMeter(), true);
  self.world:setCallbacks(BeginContact, EndContact, PreSolve, PostSolve);
end

-- updates the world
function World:Update(_dt)
  self.world:update(_dt);
end

return World;
