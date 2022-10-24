local LevelLoader = {pendingChange = false, levelToLoad = "", currentLevel, previousLevel, transitionRatio = 1.0};
local FrameBuffer = require("FrameBuffer");
local Math = require("Math");

function LevelLoader:Start()
  LevelLoader.currentLevel = require("Scene_MainMenu"):new();
  LevelLoader.currentLevel:Start();
end

function LevelLoader:LoadLevel(_level)
  LevelLoader.pendingChange = true;
  LevelLoader.previousLevel = LevelLoader.levelToLoad;
  LevelLoader.levelToLoad = _level;
  LevelLoader.transitionRatio = 0.0;
end

function LevelLoader:LoadPreviousLevel()
  LevelLoader.pendingChange = true;
  LevelLoader.levelToLoad = LevelLoader.previousLevel;
  LevelLoader.transitionRatio = 0.0;
end

function LevelLoader:UpdateLevel(_dt)
  if LevelLoader.currentLevel ~= nil then
    LevelLoader.currentLevel:Update(_dt);
  end
end

function LevelLoader:KeyEvents( key, scancode, isrepeat )
  if LevelLoader.currentLevel ~= nil then
    LevelLoader.currentLevel:KeyEvents(key, scancode, isrepeat);
  end
end

function LevelLoader:DrawLevel()
  if LevelLoader.currentLevel ~= nil then
    LevelLoader.currentLevel:Draw();
  end
end

function LevelLoader:HandleSceneTransition(_dt)
  FrameBuffer.Shader.vignette.radius = Math:Lerp(1.0, 0.0, LevelLoader.transitionRatio);
  LevelLoader.transitionRatio = LevelLoader.transitionRatio + _dt * 2;
end

function LevelLoader:HandleSceneStartTransition(_dt)
  FrameBuffer.Shader.vignette.radius = Math:Lerp(0.0, 1.0, LevelLoader.transitionRatio);
  LevelLoader.transitionRatio = LevelLoader.transitionRatio + _dt * 2;
end

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
