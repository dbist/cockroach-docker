require 'pg'
require 'active_record'
require 'activerecord-cockroachdb-adapter'

# Connect to CockroachDB using ActiveRecord.
# In Rails, this configuration would go in config/database.yml as usual.
# BEGIN connect
ActiveRecord::Base.establish_connection(

  # Specify the CockroachDB ActiveRecord adapter
  adapter:     'cockroachdb',
  username:    'roach',
  password:    'roach',
  database:    'bank',
  host:        'lb',
  port:        26257,
  sslmode:     'verify-full',
  sslrootcert: '/certs/ca.crt',
  sslcert: '/certs/client.roach.crt',
  sslkey: '/certs/client.roach.key',
)
# END connect

# Define the Account model.
# In Rails, this would go in app/models/ as usual.
class Account < ActiveRecord::Base
  validates :balance, presence: true
end

# Define a migration for the accounts table.
# In Rails, this would go in db/migrate/ as usual.
class Schema < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts, force: true do |t|
      t.integer :balance
    end
  end
end

# Run the schema migration programmatically.
# In Rails, this would be done via rake db:migrate as usual.
Schema.new.change()

# Create two accounts, inserting two rows into the accounts table.
Account.create!(id: 1, balance: 1000)
Account.create!(id: 2, balance: 250)

# Retrieve accounts and print out the balances
Account.all.each do |acct|
  puts "account: #{acct.id} balance: #{acct.balance}"
end