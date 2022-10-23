local ProjectileManager = {Projectiles = {}, ProjectileCount = 0};

function ProjectileManager.CreateProjectile(_xPos, _yPos, _world, _DirectionX, _DirectionY, _speed, _isFriendly, _damage)
  ProjectileManager.ProjectileCount = ProjectileManager.ProjectileCount + 1;
  ProjectileManager.Projectiles[ProjectileManager.ProjectileCount] = require("Projectile"):new();
  ProjectileManager.Projectiles[ProjectileManager.ProjectileCount]:Create(_xPos, _yPos, _world, _DirectionX, _DirectionY, _speed, _isFriendly, _damage);
end

function ProjectileManager.Update(_dt)
  for i, v in pairs(ProjectileManager.Projectiles) do
    ProjectileManager.Projectiles[i]:Update(_dt);
  end
end

function ProjectileManager.CleanupDestroyedProjectiles()
  for i, v in pairs(ProjectileManager.Projectiles) do
    if ProjectileManager.Projectiles[i].Destroy == true then
      ProjectileManager.Projectiles[i]:Cleanup();
      ProjectileManager.Projectiles[i].Destroy = false;
      ProjectileManager.Projectiles[i] = nil;
    end
  end
end

function ProjectileManager.Draw()
  for i, v in pairs(ProjectileManager.Projectiles) do
    ProjectileManager.Projectiles[i]:Draw();
  end
end

return ProjectileManager;
