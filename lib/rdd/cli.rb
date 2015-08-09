require 'optparse'
require 'open-uri'
require 'zlib'
require 'yajl'
require 'pry'

module Rdd

  class Cli

    def self.setup(argv, stdout, stderr)

      options = { after: nil, before: nil, top: nil }

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Options:'
        opts.on("-a", "--after=AFTER", "Date to start search at, ISO8601 or YYYY-MM-DD format", "Default: 28 days ago") do |after|
          options[:after] = after
        end

        opts.on("-b", "--before=BEFORE", "ISO8601 Date to end search at, ISO8601 or YYYY-MM-DD format", "Default: Now") do |before|
          options[:before] = before
        end

        opts.on("-t", "--top=TOP", "The number of repos to show", "Default 20" ) do |top|
          options[:top] = top
        end

        opts.on("-h", "--help", "Displays Help") do
          stdout.puts opts
        end
      end

      opt_parser.parse!(argv)

    end
  end
end
