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

      described_class.notifiers.delete(:error).should =~ ['perfectly refined']
      described_class.notifiers.delete(:fatal).should =~ ['perfectly refined', 'swiftly clean']
      described_class.notifiers.values.uniq.should == [[]]
    end

    it 'allows multiple types of notification' do
      described_class.configure do |c|
        c.add_notifier 'gravy_pie'
        c.add_notifier 'assiduous_hedgehog'
      end
      described_class.notifiers.keys.should == RfLogger::LEVELS
      described_class.notifiers.values.uniq.tap do |unique_notifiers|
        unique_notifiers.count.should == 1
        unique_notifiers[0].should =~ ['assiduous_hedgehog', 'gravy_pie']
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
        unique_notifiers.count.should == 1
        unique_notifiers[0].should == ['terribly sweet']
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
        n.should_receive(:send_notification).with(log)
      end
      described_class.dispatch_error(log)
    end
  end
end
