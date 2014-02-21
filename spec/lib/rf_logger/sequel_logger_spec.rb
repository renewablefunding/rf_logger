describe RfLogger::SequelLogger do
  before :each do
    Time.stub(:now => 'NOW')
    described_class.dataset = 
      DB[:logs].columns(:actor, :action, :target_type, :target_id,
               :metadata, :created_at, :updated_at, :level)
  end

  RfLogger::LEVELS.each do |level|
    describe ".#{level}" do
      it "logs information in the database with #{level.upcase} level" do
        described_class.should_receive(:add).
          with(level, :something => :happened)
        described_class.send(level.to_sym, :something => :happened)
      end

      it 'dispatches error notifications' do
        described_class.stub(:add)
        RfLogger::ErrorNotification.should_receive(:dispatch_error)
        described_class.send(level.to_sym, :something => :happened)
      end
    end
  end

  describe '.add' do
    it 'adds given object to the log at given level' do
      RfLogger::SequelLogger.should_receive(:create).with(
        :actor => 'cat herder',
        :action => 'herd some cats',
        :target_type => 'Cat',
        :target_id => 'cat_numero_tres',
        :metadata => {
          :message => 'There are cats everywhere',
          :danger => {
            :level => 'really_high',
            :rodent => 'mouse',
          }
        },
        :level => RfLogger::LEVELS.index(:info),
        :created_at => 'NOW',
      )

      described_class.add(:info, {
        :actor => 'cat herder',
        :action => 'herd some cats',
        :target_type => 'Cat',
        :target_id => 'cat_numero_tres',
        :metadata => {
          :message => 'There are cats everywhere',
          :danger => {
            :level => 'really_high',
            :rodent => 'mouse',
          }
        }
      })
    end

    it 'sets actor to blank string if not provided' do
      described_class.should_receive(:create).with(
        :actor => '',
        :action => 'palpitate',
        :metadata => {},
        :created_at => 'NOW',
        :level => RfLogger::LEVELS.index(:info))

      described_class.add(:info, { :action => 'palpitate' })
    end

    it 'sets metadata to empty hash if not provided' do
      described_class.should_receive(:create).with(
        :actor => '',
        :action => 'palpitate',
        :metadata => {},
        :created_at => 'NOW',
        :level => RfLogger::LEVELS.index(:info)
      )

      described_class.add(:info, { :action => 'palpitate' })
    end
  end
end
