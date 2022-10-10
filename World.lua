function InitWorld()
  love.physics.setMeter(64);
  world = love.physics.newWorld(0, 0, true);
  world:setCallbacks(BeginContact, EndContact, PreSolve, PostSolve);
end
