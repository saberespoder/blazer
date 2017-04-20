require 'slack-notifier'

module Blazer
  class SlackNotifier
    def initialize
      @notifier ||= Slack::Notifier.new ENV.fetch('WEBHOOK_URL'), channel: ENV.fetch('SLACK_CHANNEL'),
                                                                  username: ENV.fetch('SLACK_USERNAME')
    end

    def state_change(check, state, state_was, rows_count)
      message = "'#{check.query.name}' check changed status from #{state_was} to #{state}. It now returns #{rows_count} rows. @alessio @etavenn @skatkov"
      @notifier.ping(message)
    end

    def failing_checks(checks)
      msg = "Checks failing.\n"
      checks.each { |c| msg << "#{c.query.name} (#{c.state})" }
      @notifier.ping(msg)
    end

    def self.notifier
      Slack::Notifier.new ENV.fetch('WEBHOOK_URL'), channel: ENV.fetch('SLACK_CHANNEL'),
                                                    username: ENV.fetch('SLACK_USERNAME')
    end
  end
end
