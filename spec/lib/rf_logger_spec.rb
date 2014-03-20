describe RfLogger do
  describe ".configure" do
    it 'yields the current configuration' do
      existing_configuration = described_class.configuration
      described_class.configure do |c|
        expect(c).to equal(existing_configuration)
      end
    end

    it 'allows multiple cumulative configuration blocks' do
      described_class.configure do |c|
        c.notification_subject = 'Foo'
      end

      described_class.configure do |c|
        c.environment = 'production'
      end

      described_class.configuration.notification_subject.should == 'Foo'
      described_class.configuration.environment.should == 'production'
    end

    it 'requires a block' do
      expect { described_class.configure }.to raise_error(ArgumentError)
    end
  end

  describe ".configure!" do
    it 'resets configuration and yields new configuration' do
      existing_configuration = described_class.configuration { |c| c.environment = 'boo' }
      described_class.configure! do |c|
        expect(c).not_to equal(existing_configuration)
        expect(c).to equal(described_class.configuration)
      end
    end

    it 'requires a block and does not reset without one' do
      existing_configuration = described_class.configuration { |c| c.environment = 'boo' }
      expect { described_class.configure! }.to raise_error(ArgumentError)
      expect(described_class.configuration).to eq(existing_configuration)
    end
  end

  describe '.clear_configuration!' do
    it 'resets configuration' do
      old_config = described_class.configuration
      described_class.clear_configuration!
      described_class.configuration.should_not == old_config
    end
  end

  describe '.environment' do
    it 'can set directly' do
      described_class.environment = 'foo'
      described_class.configuration.environment.should == 'foo'
    end
  end

  describe '.configuration' do
    it 'creates an instance of RfLogger::Configuration' do
      described_class.configuration.should be_an_instance_of(RfLogger::Configuration)
    end

    it 'returns the same instance when called multiple times' do
      configuration = described_class.configuration
      described_class.configuration.should == configuration
    end
  end
end
