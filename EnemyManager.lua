--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : EnemyManager.lua
--Description : EnemyManager Implementation File
--Author : Will Inman

local EnemyManager = {World, Enemies = {}, EnemyCount = 0};

-- Initializes the enemy manager with a world
function EnemyManager.Init(_world)
  EnemyManager.World = _world;
end

-- Creates a lober at the given position
function EnemyManager.CreateLober(_xPos, _yPos)
  EnemyManager.EnemyCount = EnemyManager.EnemyCount + 1;
  EnemyManager.Enemies[EnemyManager.EnemyCount] = require("Lober"):new();
  EnemyManager.Enemies[EnemyManager.EnemyCount]:Create(_xPos, _yPos, EnemyManager.World);
end

-- Creates an onion at the given position
function EnemyManager.CreateOnion(_xPos, _yPos)
  EnemyManager.EnemyCount = EnemyManager.EnemyCount + 1;
  EnemyManager.Enemies[EnemyManager.EnemyCount] = require("Onion"):new();
  EnemyManager.Enemies[EnemyManager.EnemyCount]:Create(_xPos, _yPos, EnemyManager.World);
end

-- Creates a bullseye at the given position
function EnemyManager.CreateBullseye(_xPos, _yPos)
  EnemyManager.EnemyCount = EnemyManager.EnemyCount + 1;
  EnemyManager.Enemies[EnemyManager.EnemyCount] = require("Bullseye"):new();
  EnemyManager.Enemies[EnemyManager.EnemyCount]:Create(_xPos, _yPos, EnemyManager.World);
end

-- returns the number of enemys
function EnemyManager.GetEnemyCount()
  return EnemyManager.EnemyCount;
end

-- updates all enemies
function EnemyManager.Update(_dt)
  for i, v in pairs(EnemyManager.Enemies) do
    EnemyManager.Enemies[i]:Update(_dt);
  end
end

-- cleans up all enemys
function EnemyManager.ForceCleanup()
  for i, v in pairs(EnemyManager.Enemies) do
    EnemyManager.Enemies[i]:Cleanup();
    EnemyManager.Enemies[i] = nil;
  end
  EnemyManager.EnemyCount = 0;
  collectgarbage("collect");
end

-- cleans up all enemies that are marked for destroy
function EnemyManager.CleanupDestroyedEnemies()
  for i, v in pairs(EnemyManager.Enemies) do
    if EnemyManager.Enemies[i].Destroy == true then
      EnemyManager.Enemies[i]:Cleanup();
      EnemyManager.Enemies[i].Destroy = false;
      EnemyManager.Enemies[i] = nil;
      EnemyManager.EnemyCount = EnemyManager.EnemyCount - 1;
    end
  end
  collectgarbage("collect");
end

-- draw all enemies
function EnemyManager.Draw()
  for i, v in pairs(EnemyManager.Enemies) do
    EnemyManager.Enemies[i]:Draw();
  end
end

return EnemyManager;
