require "rf_logger/rails_logger"
require "active_record"

describe RfLogger::RailsLogger do
  include_examples "RfLogger::RequestId", subject: described_class
  RfLogger::LEVELS.each do |level|
    before do
      allow(described_class).to receive(:create)
      allow(described_class).to receive(:table_name)
      allow(described_class).to receive(:rf_logger_request_tags){{}}
    end

    describe ".#{level}" do
      it "creates new Log object with level = #{level}" do
        described_class.send(level.to_sym, action: 'log me')
        expect(described_class).to have_received(:create).with(
          :rf_logger_request_tags => {},
          :level => RfLogger::LEVELS.index(level.to_sym),
          :action => 'log me',
          :actor => nil,
          :metadata => nil,
          :target_type => nil,
          :target_id => nil
        )
      end
    end
  end
end
