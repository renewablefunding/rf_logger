require "rf_logger/file_system/logger"

describe RfLogger::FileSystem::Logger do
  let(:file_path) { '/present/working/dir/log/rf_logger.log' }
  let(:file_dbl) { instance_double(File) }

  before {
    allow(Time).to receive_message_chain('now.utc').and_return('the time is now')
    allow(described_class).to receive(:rf_logger_request_tags).and_return('42')
    allow(Dir).to receive(:pwd).and_return('/present/working/dir')
    allow(File).to receive(:exists?).with(file_path).and_return(true)
    allow(File).to receive(:open).with(file_path, 'a').and_yield(file_dbl)
    allow(file_dbl).to receive(:puts)
  }

  RfLogger::LEVELS.each do |level|
    describe ".#{level}" do
      it "creates log entry with level = #{level}" do
        expect(described_class).to receive(:create_log).with(level, 'log this')
        described_class.send(level.to_sym, 'log this')
      end
    end
  end

  describe '.create_log' do
    let(:entry) {{
      :action      => 'running',
      :actor       => 'Ben Affleck',
      :metadata    => 'so meta',
      :target_type => 'the round, bullseye kind',
      :target_id   => 'round'
    }}

    let(:log) { {
      :timestamp    => 'the time is now',
      :level        => 'bad',
      :request_tag  => '42',
      :action       => 'running',
      :actor        => 'Ben Affleck',
      :metadata     => 'so meta',
      :target_type  => 'the round, bullseye kind',
      :target_id    => 'round'
    }.to_json }

    it "writes log entry to file" do
      expect(file_dbl).to receive(:puts).with(log)
      described_class.create_log('bad', entry)
    end

    context "log file doesn't exist" do
      before { allow(File).to receive(:exists?).with(file_path).and_return(false) }
      it "creates the log file" do
        expect(FileUtils).to receive(:touch).with(file_path)
        described_class.create_log('so good', entry)
      end
    end
  end

  describe '.file_path' do
    it 'returns the log file path' do
      expect(described_class.file_path).to eq(file_path)
    end
  end
end
