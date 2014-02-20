describe RfLogger::Configuration do
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
      configuration.environment.should == 'test'
    end

    it 'uses Rails.env if Rails is defined' do
      class Rails
        def self.env
          'monkey'
        end
      end

      configuration.environment.should == 'monkey'
    end

    it 'uses Padrino.environment if defined' do
      class Padrino
        def self.environment
          'padrino'
        end
      end

      configuration.environment.should == 'padrino'
    end

    it 'uses Sinatra::Application.environment if defined' do
      class Sinatra
        class Application
          def self.environment
            'sinatra'
          end
        end
      end

      configuration.environment.should == 'sinatra'
    end

    it 'uses ENV["RORY_STAGE"] if Rory is defined' do
      class Rory
      end
      ENV['RORY_STAGE'] = 'rory'

      configuration.environment.should == 'rory'
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
      configuration.notification_subject.should be_nil
    end

    it 'resets environmental error notifier settings' do
      RfLogger.configuration.stub(:environment => 'test')
      configuration.set_notifier_list { |n| n.add_notifier SomeNotifier }
      configuration.clear!
      configuration.notifiers.keys.should =~ RfLogger::LEVELS
      configuration.notifiers.values.uniq.should == [[]]
    end
  end

  describe 'notification_subject' do
    it 'sets the value' do
      configuration.notification_subject = 'Foo!'
      configuration.notification_subject.should == 'Foo!'
    end
  end

  describe 'set_notifier_list' do
    class SomeOtherNotifier; end
    class AThirdNotifier; end
    it 'calls add_notifier on ErrorNotification and adds the notifier to config list' do
      RfLogger.configuration.stub(:environment => 'test')

      configuration.set_notifier_list do |n|
        n.add_notifier SomeNotifier, :only => ['test'], :levels => [:fatal]
        n.add_notifier SomeOtherNotifier, :except => ['test'], :levels => [:fatal]
        n.add_notifier AThirdNotifier, :levels => [:fatal]
      end

      configuration.notifiers.delete(:fatal).should =~ [SomeNotifier, AThirdNotifier]
      # all other levels shouldn't have notifiers
      configuration.notifiers.values.uniq.should == [[]]
    end
  end
end
