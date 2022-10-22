local Player = require("Player");

function BeginContact(_bodyA, _bodyB, _collision)
  if _bodyA:getUserData() == "player" and _bodyB:getUserData() == "floor" then
    Player.IsGrounded = true;
  elseif _bodyB:getUserData() == "player" and _bodyA:getUserData() == "floor" then
    Player.IsGrounded = true;
  end
end

function EndContact(_bodyA, _bodyB, _collision)
  if _bodyA:getUserData() == "player" and _bodyB:getUserData() == "floor" then
    Player.IsGrounded = false;
  elseif _bodyB:getUserData() == "player" and _bodyA:getUserData() == "floor" then
    Player.IsGrounded = false;
  end
end

function PreSolve(_bodyA, _bodyB, _collision)

end

function PostSolve(_bodyA, _bodyB, _collision, _normalImpulse, _tangentImpulse)

end
