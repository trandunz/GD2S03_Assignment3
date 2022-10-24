LevelLoader = require("LevelLoader");
local Framebuffer = require("FrameBuffer");
Math = require("Math");
WindowSize = require("Vec2"):new();
DebugDraw = false;
TimeScale = 1;
MasterVolume = 0.5;
EffectVolume = 0.75;
MusicVolume = 0.25;

function love.load(arg)
  WindowSize.x = 1280;
  WindowSize.y = 720;
  love.window.setMode(WindowSize.x, WindowSize.y, {resizable = false, vsync = true});

  Framebuffer:InitFrameBuffer();
  LevelLoader:Start();
end

function love.update(dt)
  local deltaTime = dt * TimeScale;

  LevelLoader:UpdateLevel(deltaTime);
  LevelLoader:LoadIfPending(dt);
end

function love.keypressed( key, scancode, isrepeat )
  LevelLoader:KeyEvents(key, scancode, isrepeat);
end

function love.draw()
  Framebuffer:Bind();
  LevelLoader:DrawLevel();
  Framebuffer:UnBind();
end
