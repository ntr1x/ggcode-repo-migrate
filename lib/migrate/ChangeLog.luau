local Meta = require('core/Meta')
local Project = require('core/Project')
local ChangeSet = require('migrate/changelog/ChangeSet')

local ChangeLog = {
  __type = 'ChangeLog',

  ChangeSet = ChangeSet,

  project = nil,
  name = nil,
  sequence = nil,
}

function ChangeLog:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function ChangeLog:from(project: Project, name: string)
  return ChangeLog:new({
    project = project,
    name = name,
    sequence = Meta:array {}
  })
end

function ChangeLog:with_changeset(changeset: ChangeSet)
  self.sequence[#self.sequence + 1] = changeset
  return self
end

function ChangeLog:with_rules(children: table)
  children = children or Meta:array {}

  for _, child in children do
    if child.__type == 'ChangeSet' then
      self.sequence[#self.sequence + 1] = child
    end
  end

  return self
end

function ChangeLog:unwrap_sequence()
  local sequence = Meta:array {}
  for _, changeset in self.sequence do
    sequence[#sequence + 1] = changeset:unwrap()
  end
  return sequence
end

function ChangeLog:unwrap_changelog()
  return {
    name = self.name or 'changelog',
  }
end

function ChangeLog:unwrap()
  return {
    project = self.project:unwrap_project(),
    changelog = self:unwrap_changelog(),
    sequence = self:unwrap_sequence(),
  }
end

return ChangeLog
