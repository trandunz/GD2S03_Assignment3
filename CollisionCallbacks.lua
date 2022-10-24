local Player = require("Player");

function BeginContact(_fixtureA, _fixtureB, _collision)
  if _fixtureA:getUserData() == "player" and _fixtureB:getUserData() == "floor" then
    Player.IsGrounded = true;
  elseif _fixtureB:getUserData() == "player" and _fixtureA:getUserData() == "floor" then
    Player.IsGrounded = true;
  end

  if _fixtureA:getUserData() == "projectile" and _fixtureB:getUserData() == "projectile" then
      local projectile = _fixtureA:getBody():getUserData();
      local projectile2 = _fixtureB:getBody():getUserData()
      projectile.Destroy = true;
      projectile2.Destroy = true;
  elseif _fixtureB:getUserData() == "projectile" and _fixtureA:getUserData() == "projectile" then
      local projectile = _fixtureB:getBody():getUserData()
      local projectile2 = _fixtureA:getBody():getUserData()
      projectile.Destroy = true;
      projectile2.Destroy = true;
  end

  if _fixtureA:getUserData() == "projectile" and _fixtureB:getUserData() == "floor" then
      local projectile = _fixtureA:getBody():getUserData();
      projectile.Destroy = true;
  elseif _fixtureB:getUserData() == "projectile" and _fixtureA:getUserData() == "floor" then
      local projectile = _fixtureB:getBody():getUserData()
      projectile.Destroy = true;
  end

  if _fixtureA:getUserData() == "projectile" then
    local projectile = _fixtureA:getBody():getUserData();

    if _fixtureB:getUserData() == "enemy" then
      if projectile.IsFriendly == true then
        local enemy = _fixtureB:getBody():getUserData();
        enemy:TakeDamage(projectile.Damage);
        projectile.Destroy = true;
      end
    elseif _fixtureB:getUserData() == "player" then
      if projectile.IsFriendly == false then
        Player.TakeDamage(projectile.Damage);
        projectile.Destroy = true;
      end
    end

  elseif _fixtureB:getUserData() == "projectile" then
    local projectile = _fixtureB:getBody():getUserData();

    if _fixtureA:getUserData() == "enemy" then
      if projectile.IsFriendly == true then
        local enemy = _fixtureA:getBody():getUserData();
        enemy:TakeDamage(projectile.Damage);
        projectile.Destroy = true;
      end
    elseif _fixtureA:getUserData() == "player" then
      if projectile.IsFriendly == false then
        Player.TakeDamage(projectile.Damage);
        projectile.Destroy = true;
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
