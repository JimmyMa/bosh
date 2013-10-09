require 'spec_helper'
require 'bosh/dev/sandbox/postgresql'
require 'tempfile'

module Bosh::Dev::Sandbox
  describe Postgresql do
    subject(:postgresql) { described_class.new(directory, db_name, runner) }

    let (:directory) { Dir.mktmpdir }
    let (:db_name) { 'fake_db_name' }
    let (:runner) { instance_double('Bosh::Core::Shell') }

    describe '#dump' do
      it 'saves the postgresql db with pg_dump' do
        runner.should_receive(:run).with(
            "pg_dump --host #{directory} --format=custom --file=#{directory}/postgresql_backup #{db_name}")
        postgresql.dump
      end
    end

    describe '#restore' do
      it 'restores the last dump with pg_load' do
        runner.should_receive(:run).with(
            "pg_restore --host #{directory} --clean --format=custom --file=#{directory}/postgresql_backup")
        postgresql.restore
      end
    end

    describe '#create_db' do
      it 'creates a database' do
        runner.should_receive(:run).with(
            "createdb #{db_name}")
        postgresql.create_db
      end
    end

    describe '#drop_db' do
      it 'drops a database' do
        runner.should_receive(:run).with(
            "dropdb #{db_name}")
        postgresql.drop_db
      end
    end
  end
end
