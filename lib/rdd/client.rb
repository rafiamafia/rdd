require 'big_query'

module Rdd

  class Client

    def initialize(opts)
      @opts = opts
      @bq = BigQuery::Client.new(@opts.reject { |opt| opt == :after || opt == :before || opt == :top })
    end

    def query
      sql_query = "SELECT repo_name,
                   SUM (
                    CASE
                      WHEN type = 'CreateEvent' THEN 10
                      WHEN type = 'ForkEvent' THEN 5
                      WHEN type = 'MemberEvent' THEN 3
                      WHEN type = 'PullRequestEvent' THEN 2
                      ELSE 1
                    END) as sum
                   FROM
                   (
                    SELECT type, repo.name as repo_name, actor.login,
                    JSON_EXTRACT(payload, '$.action') as event,
                    FROM
                      (TABLE_DATE_RANGE([githubarchive:day.events_],
                        TIMESTAMP('#{@opts[:after].to_s}'),
                        TIMESTAMP('#{@opts[:before].to_s}'))
                       )
                    WHERE type in ('CreateEvent', 'ForkEvent', 'MemberEvent', 'PullRequestEvent', 'WatchEvent', 'IssuesEvent')
                   )
                   GROUP BY repo_name
                   LIMIT #{@opts[:top]}"

      start_time = Time.now
      raw_result = @bq.query sql_query
      end_time = Time.now
      { start: start_time, end: end_time, response: custom_result(raw_result['rows']) }
    end

    def custom_result(arr)
      Hash[*arr.map(&:values).map(&:first).collect { |k, v| [k.values, v.values] }.flatten]
    end

  end

end
