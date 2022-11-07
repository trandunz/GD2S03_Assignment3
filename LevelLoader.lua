--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : LevelLoader.lua
--Description : LevelLoader Implementation File
--Author : Will Inman

local LevelLoader = {pendingChange = false, levelToLoad = "", currentLevel, previousLevel, transitionRatio = 1.0};
local FrameBuffer = require("FrameBuffer");
local Math = require("Math");

-- Create the starting scene and initialize it
function LevelLoader:Start()
  LevelLoader.currentLevel = require("Scene_MainMenu"):new();
  LevelLoader.currentLevel:Start();
end

-- Specify a level to load at the end of update
function LevelLoader:LoadLevel(_level)
  LevelLoader.pendingChange = true;
  LevelLoader.previousLevel = LevelLoader.levelToLoad;
  LevelLoader.levelToLoad = _level;
  LevelLoader.transitionRatio = 0.0;
end

-- Sets the previous level to load at the end of update
function LevelLoader:LoadPreviousLevel()
  LevelLoader.pendingChange = true;
  LevelLoader.levelToLoad = LevelLoader.previousLevel;
  LevelLoader.transitionRatio = 0.0;
end

-- Updates the currently active level
function LevelLoader:UpdateLevel(_dt)
  if LevelLoader.currentLevel ~= nil then
    LevelLoader.currentLevel:Update(_dt);
  end
end

-- Passes through the key callback to the current level
function LevelLoader:KeyEvents( _key, _scancode, _isrepeat )
  if LevelLoader.currentLevel ~= nil then
    LevelLoader.currentLevel:KeyEvents(_key, _scancode, _isrepeat);
  end
end

-- Draws the current level
function LevelLoader:DrawLevel()
  if LevelLoader.currentLevel ~= nil then
    LevelLoader.currentLevel:Draw();
  end
end

-- Handles scene end transition
function LevelLoader:HandleSceneTransition(_dt)
  FrameBuffer.Shader.vignette.radius = Math:Lerp(1.0, 0.0, LevelLoader.transitionRatio);
  LevelLoader.transitionRatio = LevelLoader.transitionRatio + _dt * 2;
end

-- Handles scene start transition
function LevelLoader:HandleSceneStartTransition(_dt)
  FrameBuffer.Shader.vignette.radius = Math:Lerp(0.0, 1.0, LevelLoader.transitionRatio);
  LevelLoader.transitionRatio = LevelLoader.transitionRatio + _dt * 2;
end

-- Cleanup the current level and Load a new one if it is pending
function LevelLoader:LoadIfPending(_dt)
  if LevelLoader.pendingChange == true then
    if LevelLoader.transitionRatio > 1.0 then
      LevelLoader.transitionRatio = 0.0;
      LevelLoader.currentLevel:Cleanup();
      LevelLoader.currentLevel = nil;
      collectgarbage("collect");
      LevelLoader.currentLevel = require(LevelLoader.levelToLoad):new();
      LevelLoader.currentLevel:Start();
      LevelLoader.pendingChange = false;
    else
      LevelLoader:HandleSceneTransition(_dt);
    end
  end
end

return LevelLoader;
