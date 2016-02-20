require 'sequel'
Sequel::Model.db = Sequel.mock
require "rf_logger/sequel/logger"

describe RfLogger::Sequel::Logger do
  include_examples "RfLogger::RequestId", subject: described_class

  it "keeps backwards compatibility" do
    expect(described_class).to eq RfLogger::SequelLogger
  end

  before :each do
    allow(Time).to receive_messages(:now => 'NOW')
    described_class.dataset =
      Sequel::Model.db[:logs].columns(:actor, :action, :target_type, :target_id,
               :metadata, :created_at, :updated_at, :level)
    allow(described_class).to receive(:rf_logger_request_tags){{request_id: "909090"}}
  end

  RfLogger::LEVELS.each do |level|
    describe ".#{level}" do
      it "logs information in the database with #{level.upcase} level" do
        expect(described_class).to receive(:add).
          with(level, :something => :happened)
        described_class.send(level.to_sym, :something => :happened)
      end

      it 'dispatches error notifications' do
        allow(described_class).to receive(:add)
        expect(RfLogger::ErrorNotification).to receive(:dispatch_error)
        described_class.send(level.to_sym, :something => :happened)
      end
    end
  end

  describe '.add' do
    it 'adds given object to the log at given level' do
      expect(described_class).to receive(:create).with(
        :actor => 'cat herder',
        :action => 'herd some cats',
        :target_type => 'Cat',
        :target_id => 'cat_numero_tres',
        :metadata => {
          :message => 'There are cats everywhere',
          :danger => {
            :level => 'really_high',
            :rodent => 'mouse',
          },
          :request_tags => { :request_id => "909090" }
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
          },
          :request_tags => { :request_id => "909090" }
        }
      })
    end

    context "when rf_logger_request_tags is empty" do
      it "return a metadata with no request_tags key" do
        allow(described_class).to receive(:rf_logger_request_tags){nil}

        expect(described_class).to receive(:create).with(
          ({ :level      => 1,
             :actor      => "",
             :metadata   => { },
             :created_at => "NOW" })
        )
        described_class.add(:info, {})
      end
    end

    it 'sets actor to blank string if not provided' do
      expect(described_class).to receive(:create).with(
        :actor => '',
        :action => 'palpitate',
        :metadata => {:request_tags=>{:request_id=>"909090"}},
        :created_at => 'NOW',
        :level => RfLogger::LEVELS.index(:info))

      described_class.add(:info, { :action => 'palpitate' })
    end

    it 'sets metadata to empty hash if not provided' do
      expect(described_class).to receive(:create).with(
        :actor => '',
        :action => 'palpitate',
        :metadata => {:request_tags=>{:request_id=>"909090"}},
        :created_at => 'NOW',
        :level => RfLogger::LEVELS.index(:info)
      )

      described_class.add(:info, { :action => 'palpitate' })
    end
  end

  describe "#metadata" do
    it 'returns a hash for metadata even though it is stored as JSON' do
      subject.metadata = {'foo' => 'bar'}
      expect(subject.metadata).to eq({'foo' => 'bar'})
    end

    it 'returns nil if column is null' do
      subject.metadata = nil
      expect(subject.metadata).to be_nil
    end
  end

  describe 'display_level' do
    it 'returns a human-readable level instead of an integer' do
      subject.level = 1
      expect(subject.display_level).to eq(:info)
    end
  end
end
