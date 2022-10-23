local Math = {};

function Math:Lerp(_a, _b, _t)
  return _a * (1.0 - _t) + (_b * _t);
end

function Math:Distance(_v1, _v2)
  return (_v2 - _v1):Mag();
end

return Math;
