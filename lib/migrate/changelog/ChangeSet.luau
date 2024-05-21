local Meta = require('core/Meta')

local ChangeSet = {
  __type = 'ChangeSet',
  tag = nil,
  directory = nil,
  author = nil,
  description = nil,
  up_scripts = nil,
  down_scripts = nil,
}

function ChangeSet:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function ChangeSet:from(tag: string, directory: string, author: string, description: string)
  return ChangeSet:new({
    tag = tag,
    directory = directory,
    author = author,
    description = description,
    up_scripts = Meta:array {},
    down_scripts = Meta:array {},
  })
end

function ChangeSet:with_up_scripts(scripts: table)
  for i, name in scripts do
    self.up_scripts[#self.up_scripts + 1] = name
  end
  return self
end

function ChangeSet:with_down_scripts(scripts: table)
  for i, name in scripts do
    self.down_scripts[#self.down_scripts + 1] = name
  end
  return self
end

function ChangeSet:unwrap_changeset()
  return {
    tag = self.tag,
    author = self.author,
    description = self.description,
  }
end

function ChangeSet:unwrap()
  return {
    changeset = self:unwrap_changeset(),
    up_scripts = self.up_scripts,
    down_scripts = self.down_scripts,
  }
end

return ChangeSet
