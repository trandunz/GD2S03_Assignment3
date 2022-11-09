--Bachelor of Software Engineering
--Media Design School
--Auckland
--New Zealand
--(c) Media Design School
--File Name : Math.lua
--Description : Math Implementation File
--Author : Will Inman

local Math = {};

-- returns a linear interpolaed value from a to b based on the ratio (0->1) _t
function Math:Lerp(_a, _b, _t)
  return _a * (1.0 - _t) + (_b * _t);
end

-- returns the distance between the two vectors
function Math:Distance(_v1, _v2)
  return (_v2 - _v1):Mag();
end

return Math;
