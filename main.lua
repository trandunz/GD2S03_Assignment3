LevelLoader = require("LevelLoader");
local Framebuffer = require("FrameBuffer");
Math = require("Math");
WindowSize = require("Vec2"):new();
DebugDraw = false;
TimeScale = 1;
AudioManager = require("AudioManager");

function love.load(arg)
  WindowSize.x = 1280;
  WindowSize.y = 720;
  love.window.setMode(WindowSize.x, WindowSize.y);

  Framebuffer:InitFrameBuffer();
  LevelLoader:Start();
end

function love.update(dt)
  local deltaTime = dt * TimeScale;
  LevelLoader:UpdateLevel(deltaTime);
  LevelLoader:LoadIfPending(deltaTime);
end

function love.keypressed( key, scancode, isrepeat )
  LevelLoader:KeyEvents(key, scancode, isrepeat);
end

function love.draw()
  Framebuffer:Bind();
  LevelLoader:DrawLevel();
  Framebuffer:UnBind();
end
