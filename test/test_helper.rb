# frozen_string_literal: true

require "active_record"
require "paranoia"
require "orthoses/paranoia"
require "rgot/cli"

Orthoses.logger.level = :error
unless $PROGRAM_NAME.end_with?("/rgot")
  at_exit do
    exit Rgot::Cli.new(["-v", "lib"]).run
  end
end
