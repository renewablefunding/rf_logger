require "rf_logger/rails_logger"
require "active_record"

describe RfLogger::RailsLogger do
  include_examples "RfLogger::RequestId", subject: described_class
  RfLogger::LEVELS.each do |level|
    before do
      allow(described_class).to receive(:create)
      allow(described_class).to receive(:table_name)
    end

    describe ".#{level}" do
      context "when rf_logger_request_tags is empty" do
        it "creates new Log object with level = #{level}" do
          allow(described_class).to receive(:rf_logger_request_tags){nil}
          described_class.send(level.to_sym, action: 'log me')
          expect(described_class).to have_received(:create).with(
            :level => RfLogger::LEVELS.index(level.to_sym),
            :action => 'log me',
            :actor => nil,
            :metadata => {},
            :target_type => nil,
            :target_id => nil,
          )
        end
      end

      context "when rf_logger_request_tags is not empty" do
        it "creates new Log object with level = #{level}" do
          allow(described_class).to receive(:rf_logger_request_tags){{test: "hello"}}
          described_class.send(level.to_sym, action: 'log me')
          expect(described_class).to have_received(:create).with(
            :level => RfLogger::LEVELS.index(level.to_sym),
            :action => 'log me',
            :actor => nil,
            :metadata => {:request_tags => {test: "hello"}},
            :target_type => nil,
            :target_id => nil,
          )
        end
      end
    end
  end
end
