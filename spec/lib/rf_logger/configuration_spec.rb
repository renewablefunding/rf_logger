require "rf_logger/notifications/error_notification"
require "rf_logger/configuration"
require "rf_logger/levels"

RSpec.describe RfLogger::Configuration do
  class SomeNotifier; end
  let(:configuration) {described_class.new}
  before :each do
    configuration.clear!
  end

  after :each do
    Object.send(:remove_const, :Rails) if defined?(Rails)
    Object.send(:remove_const, :Rory) if defined?(Rory)
    Object.send(:remove_const, :Padrino) if defined?(Padrino)
    Object.send(:remove_const, :Sinatra) if defined?(Sinatra::Application)
  end

  describe "#environment" do
    it 'raises an error if client did not define' do
      expect{configuration.environment}.to raise_error RfLogger::UndefinedSetting
    end

    it 'returns environment set by user' do
      configuration.environment = 'test'
      expect(configuration.environment).to eq('test')
    end

    it 'uses Rails.env if Rails is defined' do
      class Rails
        def self.env
          'monkey'
        end
      end

      expect(configuration.environment).to eq('monkey')
    end

    it 'uses Padrino.environment if defined' do
      class Padrino
        def self.environment
          'padrino'
        end
      end

      expect(configuration.environment).to eq('padrino')
    end

    it 'uses Sinatra::Application.environment if defined' do
      class Sinatra
        class Application
          def self.environment
            'sinatra'
          end
        end
      end

      expect(configuration.environment).to eq('sinatra')
    end

    it 'uses ENV["RORY_STAGE"] if Rory is defined' do
      class Rory
      end
      ENV['RORY_STAGE'] = 'rory'

      expect(configuration.environment).to eq('rory')
      ENV['RORY_STAGE'] = nil
    end

    it 'raises error if automatic root detection returns nil' do
      class Rails
        def self.env
          nil
        end
      end

      expect{configuration.environment}.to raise_error RfLogger::UndefinedSetting
    end
  end

  describe '#clear!' do
    it 'resets environment' do
      configuration.environment = 'foo'
      configuration.clear!
      expect{configuration.environment}.to raise_error RfLogger::UndefinedSetting
    end

    it 'resets notification subject' do
      configuration.notification_subject = 'foo'
      configuration.clear!
      expect(configuration.notification_subject).to be_nil
    end

    it 'resets environmental error notifier settings' do
      allow(RfLogger.configuration).to receive_messages(:environment => 'test')
      configuration.set_notifier_list { |n| n.add_notifier SomeNotifier }
      configuration.clear!
      expect(configuration.notifiers.keys).to match_array(RfLogger::LEVELS)
      expect(configuration.notifiers.values.uniq).to eq([[]])
    end
  end

  describe 'notification_subject' do
    it 'sets the value' do
      configuration.notification_subject = 'Foo!'
      expect(configuration.notification_subject).to eq('Foo!')
    end
  end

  describe 'set_notifier_list' do
    class SomeOtherNotifier; end
    class AThirdNotifier; end
    it 'calls add_notifier on ErrorNotification and adds the notifier to config list' do
      allow(RfLogger.configuration).to receive_messages(:environment => 'test')

      configuration.set_notifier_list do |n|
        n.add_notifier SomeNotifier, :only => ['test'], :levels => [:fatal]
        n.add_notifier SomeOtherNotifier, :except => ['test'], :levels => [:fatal]
        n.add_notifier AThirdNotifier, :levels => [:fatal]
      end

      expect(configuration.notifiers.delete(:fatal)).to match_array([SomeNotifier, AThirdNotifier])
      # all other levels shouldn't have notifiers
      expect(configuration.notifiers.values.uniq).to eq([[]])
    end
  end
end
