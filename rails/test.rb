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
  port:        26000,
  sslmode:     'verify-full',
  sslrootcert: '/certs/ca.crt',
  sslcert: '/certs/client.roach.crt',
  sslkey: '/certs/client.roach.key',
  options: '-c default_transaction_use_follower_reads="true";'
  #"cockroachdb://roach:roach@lb:26257/bank?sslcert=%2Fcerts%2Fclient.roach.crt&sslkey=%2Fcerts%2Fclient.roach.key&sslmode=verify-full&default_transaction_use_follower_reads=on&sslrootcert=%2Fcerts%2Fca.crt"

)
# END connect

# Define the Account model.
# In Rails, this would go in app/models/ as usual.
class Account < ActiveRecord::Base
  validates :balance, presence: true
end

#Account.create!(id: 13, balance: 1000)

# Retrieve accounts and print out the balances
Account.all.each do |acct|
  puts "account: #{acct.id} balance: #{acct.balance}"
end