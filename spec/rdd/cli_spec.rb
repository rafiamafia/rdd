require 'spec_helper'
require 'rdd/cli'

RSpec.describe Rdd::Cli do

  context '.setup' do

    describe 'called with no args' do

      it 'prints statistics for default values' do
        expect { described_class.setup [], $stdout, $stderr }.to output(/Getting Github statistics for/).to_stdout
      end

    end

    describe 'called with args' do

      describe 'argument has an invalid after date' do

        it 'displays an error to correct the after date' do
          expect { described_class.setup ["--after", "2015", "--before", "2015-03-18T13:00:00Z"], $stdout, $stderr }.to output("Please select a valid after date in ISO8601 or YYYY-MM-DD format\n").to_stderr
        end

      end

      describe 'argument has invalid before date' do

        it 'displays an error to correct the before date' do
          expect { described_class.setup ["--before", "2015"], $stdout, $stderr }.to output("Please select a valid before date in ISO8601 or YYYY-MM-DD format\n").to_stderr
        end

      end

      describe 'argument has a before date less than the after date' do

        it 'displays an error to correct the dates' do
          expect { described_class.setup ["--before", "2015-01-01", "--after", "2015-02-01"], $stdout, $stderr }.to output("--before: 2015-01-01 must come after --after: 2015-02-01\n").to_stderr
        end

      end

      describe 'argument has an invalid top value' do

        it 'displays an error to correct the value' do
          expect { described_class.setup ["--top", "abc"], $stdout, $stderr }.to output("Please select a valid top integer value\n").to_stderr
        end

      end

      describe 'argument has invalid param' do

        it 'displays an error' do
          expect { described_class.setup ["--invalid"], $stdout, $stderr }.to output("invalid option: --invalid\n").to_stderr
        end

      end

    end

  end

end
