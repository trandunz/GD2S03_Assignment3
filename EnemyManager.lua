local EnemyManager = {World, Enemies = {}, EnemyCount = 0};

function EnemyManager.Init(_world)
  EnemyManager.World = _world;
end

function EnemyManager.CreateLober(_xPos, _yPos)
  EnemyManager.EnemyCount = EnemyManager.EnemyCount + 1;
  EnemyManager.Enemies[EnemyManager.EnemyCount] = require("Lober"):new();
  EnemyManager.Enemies[EnemyManager.EnemyCount]:Create(_xPos, _yPos, EnemyManager.World);
end

function EnemyManager.Update(_dt)
  for i, v in pairs(EnemyManager.Enemies) do
    EnemyManager.Enemies[i]:Update(_dt);
  end
end

function EnemyManager.CleanupDestroyedEnemies()
  for i, v in pairs(EnemyManager.Enemies) do
    if EnemyManager.Enemies[i].Destroy == true then
      EnemyManager.Enemies[i]:Cleanup();
      EnemyManager.Enemies[i].Destroy = false;
      EnemyManager.Enemies[i] = nil;
    end
  end
end

function EnemyManager.Draw()
  for i, v in pairs(EnemyManager.Enemies) do
    EnemyManager.Enemies[i]:Draw();
  end
end

return EnemyManager;
