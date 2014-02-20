require 'spec_helper'

describe ErrorNotification do
  before :each do
    RfLogger.configuration.environment = 'test'
    described_class.configure do |c|
      c.add_notifier 'gravy_pie'
      c.add_notifier 'assiduous_hedgehog'
    end
  end

  after :each do
    described_class.reset!
  end

  describe 'configuration' do
    it 'allows multiple types of notification' do
      described_class.notifiers.should =~ ['assiduous_hedgehog', 'gravy_pie']
    end

    it 'allows notifications specifying particular environments' do
      RfLogger.configuration.environment = 'alpha'
      described_class.configure do |c|
        c.add_notifier 'perfectly refined', :except => ['alpha']
        c.add_notifier 'swiftly clean', :only => ['beta']
      end

      described_class.notifiers.should =~ ['assiduous_hedgehog', 'gravy_pie']
    end
  end

  describe '.dispatch_error' do
    it 'calls error_notification on all configured notifiers' do
      log = double(:log)
      described_class.notifiers.each do |n|
        n.should_receive(:send_error_notification).with(log)
      end
      described_class.dispatch_error(log)
    end
  end
end
