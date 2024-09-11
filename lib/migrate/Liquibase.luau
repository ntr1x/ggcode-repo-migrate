local Meta = require('core/Meta')

local Liquibase = {
  __type = 'Liquibase',

  changelog = nil,
  name = nil,
  uri = nil,
  username = nil,
  password = nil,
}

function Liquibase:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Liquibase:from(changelog: ChangeLog, name: string, ds: table)
  return Liquibase:new({
    changelog = changelog,
    name = name,
    uri = ds.uri,
    username = ds.username,
    password = ds.password,
  })
end

function Liquibase:unwrap_liquibase()
  return {
    name = self.name or 'liquibase',
    uri = self.uri,
    username = self.username,
    password = self.password,
  }
end

function Liquibase:unwrap()
  return {
    project = self.changelog.project:unwrap_project(),
    changelog = self.changelog:unwrap_changelog(),
    liquibase = self:unwrap_liquibase(),
  }
end

return Liquibase
