local ggcode = require('core/ggcode')
local Project = require('migrate/Project')
local Liquibase = require('migrate/Liquibase')
local ChangeLog = require('migrate/ChangeLog')

local project = Project:from('store')

local datasource_app = {
  uri = 'jdbc:postgresql://env_postgres:5432/app',
  username = 'app',
  password = 'app'
}

local datasource_app_local = {
  uri = 'jdbc:postgresql://localhost:5432/app',
  username = 'app',
  password = 'app'
}

local changelog = ChangeLog
  :from(project, 'migrate')
  :with_rules {
    ChangeLog.ChangeSet
      :from('1.0.0', 'Developer', "Setup customer tables")
      :with_up_scripts({
        'v1.0/create/customer.sql',
        'v1.0/create/customer_verify_email.sql',
        'v1.0/create/customer_verify_phone.sql',
        'v1.0/create/agent.sql',
        'v1.0/create/event.sql'
      }),
    ChangeLog.ChangeSet
      :from('1.0.1', 'Developer', "Setup catalogue tables")
      :with_up_scripts({
        'v1.0/create/category.sql',
        'v1.0/create/product.sql'
      }),
    ChangeLog.ChangeSet
      :from('1.0.2', 'Developer', "Setup basket tables")
      :with_up_scripts({
        'v1.0/create/favorite.sql',
        'v1.0/create/basket.sql',
        'v1.0/create/basket_entry.sql'
      }),
    ChangeLog.ChangeSet
      :from('1.0.3', 'Developer', "Setup order tables")
      :with_up_scripts({
        'v1.0/create/order_status.sql',
        'v1.0/create/order_type.sql',
        'v1.0/create/order.sql',
        'v1.0/create/order_entry.sql',
        'v1.0/create/payment_status.sql',
        'v1.0/create/payment_type.sql',
        'v1.0/create/payment.sql'
      }),
  }

local liquibase = Liquibase:from(changelog, 'liquibase', datasource_app)
local liquibase_local = Liquibase:from(changelog, 'liquibase_local', datasource_app_local)

ggcode.generate "@/changelog" { target = '@app', variables = changelog:unwrap() }
ggcode.generate "@/liquibase" { target = '@app', variables = liquibase:unwrap() }
ggcode.generate "@/liquibase" { target = '@app', variables = liquibase_local:unwrap() }
