LevelLoader = require("LevelLoader");
local Framebuffer = require("FrameBuffer");

function love.load(arg)
  love.window.setMode(800, 800);

  --sti = require("sti");
  --map = sti("Resources/Tilemaps/ExampleTimemap.lua");
  Framebuffer:InitFrameBuffer();
  LevelLoader:Start();
end

function love.update(dt)
  LevelLoader:UpdateLevel(dt);
  LevelLoader:LoadIfPending(dt);
  --map:update(dt);
end

function love.keypressed( key, scancode, isrepeat )
  LevelLoader:KeyEvents(key, scancode, isrepeat);
end

function love.draw()
  Framebuffer:Bind();
  LevelLoader:DrawLevel();
  Framebuffer:UnBind();
  --map:drawLayer(map.layers["Tile Layer 1"]);
end
