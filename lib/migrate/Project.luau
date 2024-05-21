local Meta = require('core/Meta')

local Project = {
  __type = 'Project',

  name = nil,
}

function Project:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Project:from(name: string)
  return Project:new({
    name = name,
  })
end

function Project:unwrap_project()
  return {
    name = self.name
  }
end

function Project:unwrap()
  return {
    project = self:unwrap_project(),
  }
end

return Project
