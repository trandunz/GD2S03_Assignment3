local Player = require("Player");

function BeginContact(_fixtureA, _fixtureB, _collision)
  if _fixtureA:getUserData() == "player" and _fixtureB:getUserData() == "floor" then
    Player.IsGrounded = true;
  elseif _fixtureB:getUserData() == "player" and _fixtureA:getUserData() == "floor" then
    Player.IsGrounded = true;
  end

  if _fixtureA:getUserData() == "player" and _fixtureB:getUserData() == "tutorialDoor" then
    LevelLoader:LoadLevel("Scene_Overworld");
  elseif _fixtureB:getUserData() == "player" and _fixtureA:getUserData() == "tutorialDoor" then
    LevelLoader:LoadLevel("Scene_Overworld");
  end

  if _fixtureA:getUserData() == "projectile" and _fixtureB:getUserData() == "projectile" then
      local projectile = _fixtureA:getBody():getUserData();
      local projectile2 = _fixtureB:getBody():getUserData()
      if projectile.CanParry == true then
        projectile.Collided = true;
        projectile:StartParryLeway();
      elseif projectile2.CanParry == true then
        projectile2.Collided = true;
        projectile2:StartParryLeway()
      else
        projectile.Destroy = true;
        projectile2.Destroy = true;
        Player.ParticleSystem:Emit(1, projectile:GetPosition());
      end
  elseif _fixtureB:getUserData() == "projectile" and _fixtureA:getUserData() == "projectile" then
      local projectile = _fixtureB:getBody():getUserData()
      local projectile2 = _fixtureA:getBody():getUserData()
      if projectile.CanParry == true then
        projectile.Collided = true;
        projectile:StartParryLeway();
      elseif projectile2.CanParry == true then
        projectile2.Collided = true;
        projectile2:StartParryLeway()
      else
        projectile.Destroy = true;
        projectile2.Destroy = true;
        Player.ParticleSystem:Emit(1, projectile:GetPosition());
      end
  end

  if _fixtureA:getUserData() == "projectile" and _fixtureB:getUserData() == "floor" then
      local projectile = _fixtureA:getBody():getUserData();
      projectile.Destroy = true;
      Player.ParticleSystem:Emit(1, projectile:GetPosition());
  elseif _fixtureB:getUserData() == "projectile" and _fixtureA:getUserData() == "floor" then
      local projectile = _fixtureB:getBody():getUserData()
      projectile.Destroy = true;
      Player.ParticleSystem:Emit(1, projectile:GetPosition());
  end

  if _fixtureA:getUserData() == "projectile" then
    local projectile = _fixtureA:getBody():getUserData();

    if _fixtureB:getUserData() == "enemy" then
      if projectile.IsFriendly == true then
        local enemy = _fixtureB:getBody():getUserData();
        enemy:TakeDamage(projectile.Damage);
        projectile.Destroy = true;
        Player.ParticleSystem:Emit(1, projectile:GetPosition());
      end
    elseif _fixtureB:getUserData() == "player" then
      if projectile.CanParry == true then
        projectile.Collided = true;
        projectile:StartParryLeway();
        Player.ParryTimer = Player.ParryLeway;
        Player.ParryableProjectile = projectile;
      else
        Player.ParticleSystem:Emit(1, projectile:GetPosition());
        projectile.Destroy = true;
        Player.TakeDamage(projectile.Damage);
      end
    end

  elseif _fixtureB:getUserData() == "projectile" then
    local projectile = _fixtureB:getBody():getUserData();

    if _fixtureA:getUserData() == "enemy" then
      if projectile.IsFriendly == true then
        local enemy = _fixtureA:getBody():getUserData();
        enemy:TakeDamage(projectile.Damage);
        Player.ParticleSystem:Emit(1, projectile:GetPosition());
        projectile.Destroy = true;
      end
    elseif _fixtureA:getUserData() == "player" then
      if projectile.IsFriendly == false then
        if projectile.Damage > 0 then
          projectile.Destroy = true;
        end
        if projectile.CanParry == true then
          projectile.Collided = true;
          projectile:StartParryLeway();
          Player.ParryTimer = Player.ParryLeway;
          Player.ParryableProjectile = projectile;
        else
          Player.ParticleSystem:Emit(1, projectile:GetPosition());
          projectile.Destroy = true;
          Player.TakeDamage(projectile.Damage);
        end
      end
    end
  end

end

function EndContact(_fixtureA, _fixtureB, _collision)
  if _fixtureA:getUserData() == "player" and _fixtureB:getUserData() == "floor" then
    Player.IsGrounded = false;
  elseif _fixtureB:getUserData() == "player" and _fixtureA:getUserData() == "floor" then
    Player.IsGrounded = false;
  end
end

function PreSolve(_bodyA, _bodyB, _collision)

end

function PostSolve(_bodyA, _bodyB, _collision, _normalImpulse, _tangentImpulse)

end
