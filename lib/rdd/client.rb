require 'big_query'
module Rdd

  class Client

    def initialize(opts)
      credentials = opts.reject { |opt| opt == :after || opt == :before || opt == :top }
      bq = BigQuery::Client.new credentials
    end

  end

end
