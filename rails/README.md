# hello-world-ruby-activerecord
Simple 3 node *secure* CockroachDB cluster with HAProxy acting as load balancer

This repo has a "Hello World" Ruby application that uses the [Active Record CockroachDB Adapter](https://github.com/cockroachdb/activerecord-cockroachdb-adapter) and [pg](https://rubygems.org/gems/pg) libraries to talk to [CockroachDB](https://www.cockroachlabs.com/docs/stable/).

Prerequisites:

cockroachdb-activerecord` 7
CockroachDB 23.1

## Services
* `roach-0` - CockroachDB node
* `roach-1` - CockroachDB node
* `roach-2` - CockroachDB node
* `lb` - HAProxy acting as load balancer
* `roach-cert` - Holds certificates as volume mounts
* `rails` - rails node

## Getting started
>If you are using Google Chrome as your browser, you may want to navigate here `chrome://flags/#allow-insecure-localhost` and set this flag to `Enabled`.

## Getting Started

1. Run `./up.sh` to start the environment

2. Run `docker logs rails` to view the results

3. Run `docker exec -it roach-0 /cockroach/cockroach sql --certs=/certs --host=lb` to connecto to SQL shell

4. Run `docker exec -it roach-0 sh` to connect to a Cockroach node's shell

5. Run `docker exec -it rails sh` to connect to the rails node's shell


## Rails

`main.rb` in the rails directory has a hello world sample.
`devices.rb` is a new class to demonstrate UUID with ActiveRecord and Cockroach.
