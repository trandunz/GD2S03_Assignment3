Math = {};

function Math:Lerp(_a, _b, _t)
  return _a * (1.0 - _t) + (_b * _t);
end

return Math;
