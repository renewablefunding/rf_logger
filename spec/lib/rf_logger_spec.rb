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

      expect(described_class.configuration.notification_subject).to eq('Foo')
      expect(described_class.configuration.environment).to eq('production')
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
      expect(described_class.configuration).not_to eq(old_config)
    end
  end

  describe '.environment' do
    it 'can set directly' do
      described_class.environment = 'foo'
      expect(described_class.configuration.environment).to eq('foo')
    end
  end

  describe '.configuration' do
    it 'creates an instance of RfLogger::Configuration' do
      expect(described_class.configuration).to be_an_instance_of(RfLogger::Configuration)
    end

    it 'returns the same instance when called multiple times' do
      configuration = described_class.configuration
      expect(described_class.configuration).to eq(configuration)
    end
  end
end
