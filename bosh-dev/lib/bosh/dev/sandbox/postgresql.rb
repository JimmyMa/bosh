require 'bosh/dev'
require 'bosh/core/shell'

module Bosh::Dev::Sandbox
  class Postgresql
    attr_reader :directory

    def initialize(directory, db_name, runner = Bosh::Core::Shell.new)
      @directory = directory
      @db_name = db_name
      @runner = runner
    end

    def dump
      p "INFO: attemping to dump db #{db_name} to #{dump_path}"
      runner.run("pg_dump --format=custom --file=#{dump_path} #{db_name}")
    end

    def restore
      runner.run("pg_restore --clean --format=custom --file=#{dump_path}")
    end

    def create_db
      runner.run("createdb #{db_name}")
    end

    def drop_db
      runner.run("dropdb #{db_name}")
    end

    private

    attr_reader :db_name, :runner

    def dump_path
      "#{directory}/postgresql_backup"
    end
  end
end
