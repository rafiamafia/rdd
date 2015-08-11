require 'spec_helper'
require 'rdd/cli'
require 'timecop'

RSpec.describe Rdd::Cli do

  context '.setup' do

    describe 'called with no args' do

      let(:now) { DateTime.parse '2015-01-01' }

      before do
        Timecop.freeze(now)
      end

      it 'prints top 20 repos and the corresponding points from 28 days ago' do
        expect { described_class.setup [], $stdout, $stderr }.to output("Getting Github statistics for #{(now - 28).strftime('%F %T')} UTC - #{ now.strftime('%F %T') } UTC
          Results (~0 seconds):
          1 samueleishion/QTube - 2 points
          2 henriquea/gmaps-animated-route - 5 points
          3 hustcer/star - 723 points
          4 dongweb/test1 - 10 points
          5 LixinMa/FirstProjectByStruts - 46 points
          6 buchos92/yii - 90 points
          7 heavysixer/d4 - 26 points
          8 viljamis/FitText.js - 5 points
          9 gontovnik/DGActivityIndicatorView - 167 points
          10 Michael-Wzq/test - 50 points
          11 ethereum/go-ethereum - 856 points
          12 hungtruongquoc/tripplanner - 20 points
          13 alexportnoy/cordova-prefs-plugin - 5 points
          14 masayukioguni/godo-cli - 11 points
          15 YoQuieroSaber/votai-theme - 189 points
          16 calabash/calabash-android - 198 points
          17 Mooophy/Cpp-Primer - 442 points
          18 hbulzy/Dnn.Platform - 1 points
          19 tmpvar/jsdom - 315 points
          20 tralpha/neighborhood - 50 points").to_stdout
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

    end

  end

end
