local EnemyManager = {World, Enemies = {}, EnemyCount = 0};

function EnemyManager.Init(_world)
  EnemyManager.World = _world;
end

function EnemyManager.CreateLober(_xPos, _yPos)
  EnemyManager.EnemyCount = EnemyManager.EnemyCount + 1;
  EnemyManager.Enemies[EnemyManager.EnemyCount] = require("Lober"):new();
  EnemyManager.Enemies[EnemyManager.EnemyCount]:Create(_xPos, _yPos, EnemyManager.World);
end

function EnemyManager.CreateOnion(_xPos, _yPos)
  EnemyManager.EnemyCount = EnemyManager.EnemyCount + 1;
  EnemyManager.Enemies[EnemyManager.EnemyCount] = require("Onion"):new();
  EnemyManager.Enemies[EnemyManager.EnemyCount]:Create(_xPos, _yPos, EnemyManager.World);
end

function EnemyManager.CreateBullseye(_xPos, _yPos)
  EnemyManager.EnemyCount = EnemyManager.EnemyCount + 1;
  EnemyManager.Enemies[EnemyManager.EnemyCount] = require("Bullseye"):new();
  EnemyManager.Enemies[EnemyManager.EnemyCount]:Create(_xPos, _yPos, EnemyManager.World);
end

function EnemyManager.GetEnemyCount()
  return EnemyManager.EnemyCount;
end

function EnemyManager.Update(_dt)
  for i, v in pairs(EnemyManager.Enemies) do
    EnemyManager.Enemies[i]:Update(_dt);
  end
end

function EnemyManager.ForceCleanup()
  for i, v in pairs(EnemyManager.Enemies) do
    EnemyManager.Enemies[i]:Cleanup();
    EnemyManager.Enemies[i] = nil;
  end
  EnemyManager.EnemyCount = 0;
  collectgarbage("collect");
end

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

function EnemyManager.Draw()
  for i, v in pairs(EnemyManager.Enemies) do
    EnemyManager.Enemies[i]:Draw();
  end
end

return EnemyManager;
