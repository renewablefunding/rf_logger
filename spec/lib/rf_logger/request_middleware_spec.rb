require "rf_logger/request_middleware"

RSpec.describe RfLogger::RequestMiddleware do
  subject { RfLogger::RequestMiddleware.new(*init_arguments).call(env) }
  let(:init_arguments) { [->(_) {}] }
  before { subject }
  after { Thread.current[:rf_logger_request_id] = nil }

  context "when env responds to uuid" do
    let(:env) { double(uuid: "uuid-from_env") }
    it "sets current Thread variable" do
      expect(Thread.current[:rf_logger_request_id]).to eq "uuid-from_env"
    end
  end

  context "from custom_env_key" do
    let(:init_arguments) { [->(_) {}, { custom_env_key: "other_request_id" }] }
    let(:env) { { "other_request_id" => "uuid-from_other" } }

    it "sets current Thread variable" do
      expect(Thread.current[:rf_logger_request_id]).to eq "uuid-from_other"
    end
  end
end
