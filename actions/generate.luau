local ggcode = require('core/ggcode')
local Project = require('core/Project')
local Liquibase = require('migrate/Liquibase')
local ChangeLog = require('migrate/ChangeLog')

local project = Project:from('store_migrate')

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

local datasource_app_host = {
  uri = 'jdbc:postgresql://host.docker.internal:5432/app',
  username = 'app',
  password = 'app'
}

local changelog = ChangeLog
  :from(project)
  :with_rules {
    ChangeLog.ChangeSet
      :from('1.0.0', 'Developer', "Setup customer tables")
      :with_up_scripts({
        'ddl/public/create/customer.sql',
        'ddl/public/create/customer_verify_email.sql',
        'ddl/public/create/customer_verify_phone.sql',
        'ddl/public/create/agent.sql',
        'ddl/public/create/event.sql',
      })
      :with_down_scripts({
        'ddl/public/drop/event.sql',
        'ddl/public/drop/agent.sql',
        'ddl/public/drop/customer_verify_phone.sql',
        'ddl/public/drop/customer_verify_email.sql',
        'ddl/public/drop/customer.sql',
      }),
    ChangeLog.ChangeSet
      :from('1.0.1', 'Developer', "Setup catalogue tables")
      :with_up_scripts({
        'ddl/public/create/category.sql',
        'ddl/public/create/product.sql',
      })
      :with_down_scripts({
        'ddl/public/drop/product.sql',
        'ddl/public/drop/category.sql',
      }),
    ChangeLog.ChangeSet
      :from('1.0.2', 'Developer', "Setup basket tables")
      :with_up_scripts({
        'ddl/public/create/favorite.sql',
        'ddl/public/create/basket.sql',
        'ddl/public/create/basket_entry.sql',
      })
      :with_down_scripts({
        'ddl/public/drop/basket_entry.sql',
        'ddl/public/drop/basket.sql',
        'ddl/public/drop/favorite.sql',
      }),
    ChangeLog.ChangeSet
      :from('1.0.3', 'Developer', "Setup order tables")
      :with_up_scripts({
        'ddl/public/create/order_status.sql',
        'ddl/public/create/order_type.sql',
        'ddl/public/create/order.sql',
        'ddl/public/create/order_entry.sql',
        'ddl/public/create/payment_status.sql',
        'ddl/public/create/payment_type.sql',
        'ddl/public/create/payment.sql',
      })
      :with_down_scripts({
        'ddl/public/drop/payment.sql',
        'ddl/public/drop/payment_type.sql',
        'ddl/public/drop/payment_status.sql',
        'ddl/public/drop/order_entry.sql',
        'ddl/public/drop/order.sql',
        'ddl/public/drop/order_type.sql',
        'ddl/public/drop/order_status.sql',
      }),
  }

local liquibase = Liquibase:from(changelog, 'liquibase', datasource_app)
local liquibase_local = Liquibase:from(changelog, 'liquibase_local', datasource_app_local)
local liquibase_host = Liquibase:from(changelog, 'liquibase_host', datasource_app_host)

ggcode.generate "@/project" { target = '@app', variables = project:unwrap() }
ggcode.generate "@/changelog" { target = '@app', variables = changelog:unwrap() }
ggcode.generate "@/liquibase" { target = '@app', variables = liquibase:unwrap() }
ggcode.generate "@/liquibase" { target = '@app', variables = liquibase_local:unwrap() }
ggcode.generate "@/liquibase" { target = '@app', variables = liquibase_host:unwrap() }
