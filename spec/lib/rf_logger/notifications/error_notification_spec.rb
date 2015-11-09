require 'spec_helper'

describe RfLogger::ErrorNotification do
  before :each do
    RfLogger.configuration.environment = 'test'
  end

  after :each do
    described_class.reset!
  end

  describe 'configuration' do
    it 'allows specification of which log levels on which to notify' do
      RfLogger.configuration.environment = 'alpha'
      described_class.configure do |c|
        c.add_notifier 'perfectly refined', :levels => [:fatal, :error]
        c.add_notifier 'swiftly clean', :levels => [:fatal]
      end

      expect(described_class.notifiers.delete(:error)).to match_array(['perfectly refined'])
      expect(described_class.notifiers.delete(:fatal)).to match_array(['perfectly refined', 'swiftly clean'])
      expect(described_class.notifiers.values.uniq).to eq([[]])
    end

    it 'allows multiple types of notification' do
      described_class.configure do |c|
        c.add_notifier 'gravy_pie'
        c.add_notifier 'assiduous_hedgehog'
      end
      expect(described_class.notifiers.keys).to eq(RfLogger::LEVELS)
      described_class.notifiers.values.uniq.tap do |unique_notifiers|
        expect(unique_notifiers.count).to eq(1)
        expect(unique_notifiers[0]).to match_array(['assiduous_hedgehog', 'gravy_pie'])
      end
    end

    it 'allows notifications specifying particular environments' do
      RfLogger.configuration.environment = 'alpha'
      described_class.configure do |c|
        c.add_notifier 'perfectly refined', :except => ['alpha']
        c.add_notifier 'swiftly clean', :only => ['beta']
        c.add_notifier 'terribly sweet'
      end

      described_class.notifiers.values.uniq.tap do |unique_notifiers|
        expect(unique_notifiers.count).to eq(1)
        expect(unique_notifiers[0]).to eq(['terribly sweet'])
      end
    end
  end

  describe '.dispatch_error' do
    before :each do
      described_class.configure do |c|
        c.add_notifier 'gravy_pie'
        c.add_notifier 'assiduous_hedgehog'
      end
    end

    it 'calls error_notification on all configured notifiers' do
      log = double(:log, :level => :warn)
      described_class.notifiers[:warn].each do |n|
        expect(n).to receive(:send_notification).with(log)
      end
      described_class.dispatch_error(log)
    end
  end
end
