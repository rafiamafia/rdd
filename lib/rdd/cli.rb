require 'optparse'
require 'open-uri'
require 'zlib'
require 'yajl'
require 'pry'
require 'rdd/client'

module Rdd

  class Cli

    def self.setup(argv, stdout, stderr)

      options = {
        after:          nil,
        before:         nil,
        top:            nil,
        client_id:      '28993007729-ncj0h0jqqvsrftqirb5khsmihciokh7q.apps.googleusercontent.com',
        service_email:  '28993007729-ncj0h0jqqvsrftqirb5khsmihciokh7q@developer.gserviceaccount.com',
        key:            File.expand_path('../../data/example-49a007fbf6a3.p12', __dir__),
        project_id:     'example-1032',
        dataset:        'https://bigquery.cloud.google.com/table/githubarchive:day.events_20150101',
      }

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Options:'

        opts.on("-a", "--after=AFTER", "Date to start search at, ISO8601 or YYYY-MM-DD format", "Default: 28 days ago") do |after|
          begin
            DateTime.iso8601 after
          rescue
            stderr.puts "please select a valid after date"
            return
          end
          options[:after] = DateTime.parse(after)
        end
        options[:after] ||= DateTime.now - 28

        opts.on("-b", "--before=BEFORE", "ISO8601 Date to end search at, ISO8601 or YYYY-MM-DD format", "Default: Now") do |before|
          begin
            DateTime.iso8601 before
          rescue
            stderr.puts "please select a valid before date"
            return
          end
          options[:before] = DateTime.parse(before)
        end
        options[:before] ||= DateTime.now

        opts.on("-t", "--top=TOP", "The number of repos to show", "Default 20" ) do |top|
          if top =~ /^\d+$/
            options[:top] = top.to_i
          else
            stderr.puts "please select a valid top integer value"
            return
          end
        end
        options[:top] ||= 20

        opts.on("-h", "--help", "Displays Help") do
          stdout.puts opts
          return
        end
      end

      opt_parser.parse!(argv)

      if options[:before] < options[:after]
        stderr.puts "--before: #{options[:before]} must come after --after: #{options[:after]}"
        return
      end

      #todo: sym_keys is an issue for BigQuery
      #Rdd::Client.new(options)

    end

  end

end
