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

# Define the Device model.
# This code illustrates generation of UUID as PK
# https://guides.rubyonrails.org/v5.0/active_record_postgresql.html#uuid-primary-keys
# In Rails, this would go in app/models/ as usual.
class Device < ActiveRecord::Base
end

# Define a migration for the accounts table.
# In Rails, this would go in db/migrate/ as usual.
class Schema < ActiveRecord::Migration[6.0]
  def change
    create_table :devices, id: :uuid, default: 'gen_random_uuid()', if_not_exists: true do |t|
      t.timestamps
    end
  end
end

# Run the schema migration programmatically.
# In Rails, this would be done via rake db:migrate as usual.
Schema.new.change()

kind = 0
# Create a device
device = Device.create!(created_at: 'now()', updated_at: 'now()')

# Retrieve devices
Device.all.each do |dev|
  puts "device: #{device.id} created_at: #{device.created_at} updated_at: #{device.updated_at}"
end
