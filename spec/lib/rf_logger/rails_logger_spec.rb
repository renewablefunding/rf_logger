require File.expand_path( File.dirname( __FILE__ ) + '/../../../lib/rf_logger/rails_logger' )
require 'active_record'

describe RfLogger::RailsLogger do

  before do
    allow(described_class).to receive(:create)
  end

  RfLogger::LEVELS.each do |level|
    describe ".#{level}" do
      it "creates new Log object with level = #{level}" do
        described_class.send(level.to_sym, action: 'log me')
        expect(described_class).to have_received(:create).with(
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
