--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : ProjectileManager.lua
--Description : ProjectileManager Implementation File
--Author : Will Inman

local ProjectileManager = {Projectiles = {}, ProjectileCount = 0, AudioManager = require("AudioManager"):new()};

-- Creates a projectile with the specified paramters
function ProjectileManager.CreateProjectile(_xPos, _yPos, _world, _DirectionX, _DirectionY, _speed, _isFriendly, _damage, _type, _canParry)
  ProjectileManager.ProjectileCount = ProjectileManager.ProjectileCount + 1;
  ProjectileManager.Projectiles[ProjectileManager.ProjectileCount] = require("Projectile"):new();
  ProjectileManager.Projectiles[ProjectileManager.ProjectileCount]:Create(_xPos, _yPos, _world, _DirectionX, _DirectionY, _speed, _isFriendly, _damage, _type, _canParry);
end

-- updates all projectiles
function ProjectileManager.Update(_dt)
  ProjectileManager.AudioManager:Update();
  for i, v in pairs(ProjectileManager.Projectiles) do
    ProjectileManager.Projectiles[i]:Update(_dt);
  end
end

-- force cleans up all projectiles
function ProjectileManager.ForceCleanup()
  for i, v in pairs(ProjectileManager.Projectiles) do
    ProjectileManager.Projectiles[i]:Cleanup();
    ProjectileManager.Projectiles[i] = nil;
  end
  collectgarbage("collect");
end

-- checks if any particles are marked for destroy, destroy them
function ProjectileManager.CleanupDestroyedProjectiles()
  for i, v in pairs(ProjectileManager.Projectiles) do
    if ProjectileManager.Projectiles[i].Destroy == true then
      ProjectileManager.Projectiles[i]:Cleanup();
      ProjectileManager.Projectiles[i].Destroy = false;
      hitSound = ProjectileManager.Projectiles[i]:GetOnHitSound();
      if hitSound then
        ProjectileManager.AudioManager:CreateSound("Hit", hitSound, true, false);
      end
      if ProjectileManager.Projectiles[i].IsFriendly == true then
        math.randomseed(os.time());
        local randomSound = math.random(1,16);
        ProjectileManager.AudioManager:CreateSound("ProjHit", "Resources/Sounds/Projectile/Hit (" .. randomSound .. ").wav", true, false);
      end
      ProjectileManager.Projectiles[i] = nil;

    end
  end
  collectgarbage("collect");
end

-- draw all projectiles
function ProjectileManager.Draw()
  for i, v in pairs(ProjectileManager.Projectiles) do
    ProjectileManager.Projectiles[i]:Draw();
  end
end

return ProjectileManager;
