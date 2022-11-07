--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : CollisionCallbacks.lua
--Description : CollisionCallbacks Implementation File
--Author : Will Inman

local Player = require("Player");

-- BeginContact callback function
function BeginContact(_fixtureA, _fixtureB, _collision)
  -- If player contacts with tutorial Door, switch to overworld scene
  if _fixtureA:getUserData() == "player" and _fixtureB:getUserData() == "tutorialDoor" then
    LevelLoader:LoadLevel("Scene_Overworld");
  elseif _fixtureB:getUserData() == "player" and _fixtureA:getUserData() == "tutorialDoor" then
    LevelLoader:LoadLevel("Scene_Overworld");
  end

  -- if a projectile contact another projectile, destroy them both
  if _fixtureA:getUserData() == "projectile" and _fixtureB:getUserData() == "projectile" then
      local projectile = _fixtureA:getBody():getUserData();
      local projectile2 = _fixtureB:getBody():getUserData()
      projectile.Destroy = true;
      projectile2.Destroy = true;
      Player.ParticleSystem:Emit(1, projectile:GetPosition());
  elseif _fixtureB:getUserData() == "projectile" and _fixtureA:getUserData() == "projectile" then
      local projectile = _fixtureB:getBody():getUserData()
      local projectile2 = _fixtureA:getBody():getUserData()
      projectile.Destroy = true;
      projectile2.Destroy = true;
      Player.ParticleSystem:Emit(1, projectile:GetPosition());
  end

  -- if projectile collides with the floor then destroy it
  if _fixtureA:getUserData() == "projectile" and _fixtureB:getUserData() == "floor" then
      local projectile = _fixtureA:getBody():getUserData();
      projectile.Destroy = true;
      Player.ParticleSystem:Emit(1, projectile:GetPosition());
  elseif _fixtureB:getUserData() == "projectile" and _fixtureA:getUserData() == "floor" then
      local projectile = _fixtureB:getBody():getUserData()
      projectile.Destroy = true;
      Player.ParticleSystem:Emit(1, projectile:GetPosition());
  end

  -- If a projectile collides
  if _fixtureA:getUserData() == "projectile" then
    local projectile = _fixtureA:getBody():getUserData();

    -- With an enemy then make the enemy take damage and destroy the projectile
    if _fixtureB:getUserData() == "enemy" then
      if projectile.IsFriendly == true then
        local enemy = _fixtureB:getBody():getUserData();
        enemy:TakeDamage(projectile.Damage);
        projectile.Destroy = true;
        Player.ParticleSystem:Emit(1, projectile:GetPosition());
      end
    -- With the player then
    elseif _fixtureB:getUserData() == "player" then
      -- Start player parry leway
      if projectile.CanParry == true then
        projectile.Collided = true;
        projectile:StartParryLeway();
        Player.ParryTimer = Player.ParryLeway;
        Player.ParryableProjectile = projectile;
      -- Make the player take damage and destroy the projectile
      else
        Player.ParticleSystem:Emit(1, projectile:GetPosition());
        projectile.Destroy = true;
        Player.TakeDamage(projectile.Damage);
      end
    end
  -- If a projectile collide
  elseif _fixtureB:getUserData() == "projectile" then
    local projectile = _fixtureB:getBody():getUserData();

    -- With an enemy then make the enemy take damage and destroy the projectile
    if _fixtureA:getUserData() == "enemy" then
      if projectile.IsFriendly == true then
        local enemy = _fixtureA:getBody():getUserData();
        enemy:TakeDamage(projectile.Damage);
        Player.ParticleSystem:Emit(1, projectile:GetPosition());
        projectile.Destroy = true;
      end
    -- With the player then
    elseif _fixtureA:getUserData() == "player" then
      if projectile.IsFriendly == false then
        if projectile.Damage > 0 then
          projectile.Destroy = true;
        end
        -- Start player parry leway
        if projectile.CanParry == true then
          projectile.Collided = true;
          projectile:StartParryLeway();
          Player.ParryTimer = Player.ParryLeway;
          Player.ParryableProjectile = projectile;
        -- Make the player take damage and destroy the projectile
        else
          Player.ParticleSystem:Emit(1, projectile:GetPosition());
          projectile.Destroy = true;
          Player.TakeDamage(projectile.Damage);
        end
      end
    end
  end

end

-- End contact callback function
function EndContact(_fixtureA, _fixtureB, _collision)
end

-- Pre solve callback function
function PreSolve(_bodyA, _bodyB, _collision)
end

-- PostSolve callback function
function PostSolve(_bodyA, _bodyB, _collision, _normalImpulse, _tangentImpulse)
end
