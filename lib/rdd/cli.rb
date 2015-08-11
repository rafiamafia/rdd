require 'optparse'
require 'open-uri'
require 'zlib'
require 'pry'
require 'rdd/client'

module Rdd

  class Cli

    def self.setup(argv, stdout, stderr)

      options = {
        after:          DateTime.now - 28,
        before:         DateTime.now,
        top:            20, #todo: cap top to a max value if passed in ARGV
        'client_id'     => '28993007729-ncj0h0jqqvsrftqirb5khsmihciokh7q.apps.googleusercontent.com',
        'service_email' => '28993007729-ncj0h0jqqvsrftqirb5khsmihciokh7q@developer.gserviceaccount.com',
        'key'           => File.expand_path('../../data/example-49a007fbf6a3.p12', __dir__),
        'project_id'    => 'example-1032',
        'dataset'       =>'https://bigquery.cloud.google.com/table/githubarchive:day.events_20150101',
      }

      begin
        opt_parser = setup_options(options)

        opt_parser.on("-h", "--help", "Displays Help") do
          stdout.puts opt_parser
          return
        end

        opt_parser.parse!(argv)

        if options[:before] < options[:after]
          stderr.puts "--before: #{options[:before].strftime('%F')} must come after --after: #{options[:after].strftime('%F')}"
          return
        end

      rescue ArgumentError, OptionParser::InvalidOption => e
        stderr.puts e.message
        return
      end

      stdout.puts "Getting Github statistics for #{options[:after].strftime('%F %T')} UTC - #{options[:before].strftime('%F %T')} UTC"
      result = Rdd::Client.new(options).query
      stdout.puts "Results (~#{(result[:end] - result[:start]).to_i} seconds):"

      print result[:response]

    end

    private

    def self.print(response)
      line_no = 0
      response.map { |repo_name, points| puts "##{line_no = line_no + 1} #{repo_name} - #{points} points" }
    end

    def self.setup_options(options)
      OptionParser.new do |opts|
        opts.banner = 'Options:'

        opts.on("-a", "--after=AFTER", "Date to start search at, ISO8601 or YYYY-MM-DD format", "Default: 28 days ago") do |after|
          begin
            DateTime.iso8601(after) && DateTime.parse(after)
          rescue
            raise ArgumentError.new("Please select a valid after date in ISO8601 or YYYY-MM-DD format")
          end
          options[:after] = DateTime.parse(after)
        end

        opts.on("-b", "--before=BEFORE", "ISO8601 Date to end search at, ISO8601 or YYYY-MM-DD format", "Default: Now") do |before|
          begin
            DateTime.iso8601(before) && DateTime.parse(before)
          rescue
            raise ArgumentError.new("Please select a valid before date in ISO8601 or YYYY-MM-DD format")
          end
          options[:before] = DateTime.parse(before)
        end

        opts.on("-t", "--top=TOP", "The number of repos to show", "Default 20" ) do |top|
          if top =~ /^\d+$/
            options[:top] = top.to_i
          else
            raise ArgumentError.new("Please select a valid top integer value")
          end
        end
      end
    end

  end

end
