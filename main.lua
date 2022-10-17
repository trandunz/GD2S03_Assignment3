LevelOne = require("Scene"):new();

function love.load(arg)
  love.window.setMode(800, 800);

  --sti = require("sti");
  --map = sti("Resources/Tilemaps/ExampleTimemap.lua");

  LevelOne:Start();
end

function love.update(dt)
  LevelOne:Update(dt);

  --map:update(dt);
end

function love.draw()
  LevelOne:Draw();
  --map:drawLayer(map.layers["Tile Layer 1"]);
end
