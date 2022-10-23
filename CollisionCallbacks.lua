local Player = require("Player");

function BeginContact(_fixtureA, _fixtureB, _collision)
  if _fixtureA:getUserData() == "player" and _fixtureB:getUserData() == "floor" then
    Player.IsGrounded = true;
  elseif _fixtureB:getUserData() == "player" and _fixtureA:getUserData() == "floor" then
    Player.IsGrounded = true;
  end

  if _fixtureA:getUserData() == "projectile" and _fixtureB:getUserData() == "floor" then
      local projectile = _fixtureA:getBody():getUserData();
      projectile.Destroy = true;
  elseif _fixtureB:getUserData() == "projectile" and _fixtureA:getUserData() == "floor" then
      local projectile = _fixtureB:getBody():getUserData();
      projectile.Destroy = true;
  end

  if _fixtureA:getUserData() == "projectile" and _fixtureB:getUserData() == "enemy" then
    local projectile = _fixtureA:getBody():getUserData();
    local enemy = _fixtureB:getBody():getUserData();
    enemy:TakeDamage(projectile.Damage);
    projectile.Destroy = true;
    return;
  elseif _fixtureB:getUserData() == "projectile" and _fixtureA:getUserData() == "enemy" then
    local projectile = _fixtureB:getBody():getUserData();
    local enemy = _fixtureA:getBody():getUserData();
    enemy:TakeDamage(projectile.Damage);
    projectile.Destroy = true;
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
