describe RfLogger::SimpleLogger do
  before :each do
    RfLogger::SimpleLogger.clear!
  end

  RfLogger::LEVELS.each do |level|
    describe ".#{level}" do
      it "adds given object to the log with '#{level}' level" do
        expect(described_class).to receive(:add).
          with(level, :something => :happened)
        described_class.send(level.to_sym, :something => :happened)
      end
    end
  end

  describe '.add' do
    it 'adds given object to the log at given level' do
      described_class.add(:info, :super_serious_occurrence)
      described_class.add(:debug, :weird_thing)
      expect(described_class.entries).to eq([
        { :level => 1, :level_name => :info, :entry => :super_serious_occurrence },
        { :level => 0, :level_name => :debug, :entry => :weird_thing }
      ])
    end
  end

  describe '.entries' do
    it 'returns entries at all levels when given no filter' do
      described_class.info 'thing'
      described_class.debug 'other thing'
      described_class.info 'third thing'
      described_class.fatal 'final thing'
      expect(described_class.entries).to eq([
        { :level => 1, :level_name => :info, :entry => 'thing' },
        { :level => 0, :level_name => :debug, :entry => 'other thing' },
        { :level => 1, :level_name => :info, :entry => 'third thing' },
        { :level => 4, :level_name => :fatal, :entry => 'final thing' }
      ])
    end
  end

  describe '.clear!' do
    it 'deletes all entries' do
      expect(described_class.entries).to be_empty
      described_class.info 'thing'
      expect(described_class.entries).not_to be_empty
      described_class.clear!
      expect(described_class.entries).to be_empty
    end
  end
end
