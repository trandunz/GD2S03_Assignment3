--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Main.lua
--Description : Main Implementation File
--Author : Will Inman

LevelLoader = require("LevelLoader");
local Framebuffer = require("FrameBuffer");
Math = require("Math");
WindowSize = require("Vec2"):new();
DebugDraw = false;
TimeScale = 1;
MasterVolume = 0.5;
EffectVolume = 0.8;
MusicVolume = 0.2;

-- Main Start
function love.load(_arg)
  WindowSize.x = 1280;
  WindowSize.y = 720;
  love.window.setMode(WindowSize.x, WindowSize.y, {resizable = false, vsync = true});

  Framebuffer:InitFrameBuffer();
  LevelLoader:Start();
end

-- Main Update
function love.update(_dt)
  local deltaTime = _dt * TimeScale;

  LevelLoader:UpdateLevel(deltaTime);
  LevelLoader:LoadIfPending(_dt);
end

-- Key Callback
function love.keypressed( _key, _scancode, _isrepeat )
  LevelLoader:KeyEvents(_key, _scancode, _isrepeat);
end

-- Main Draw
function love.draw()
  Framebuffer:Bind();
  LevelLoader:DrawLevel();
  Framebuffer:UnBind();
end
