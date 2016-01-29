require "rf_logger/request_middleware"

RSpec.describe RfLogger::RequestMiddleware do
  subject { RfLogger::RequestMiddleware.new(*init_arguments).call(env) }
  let(:env) { {} }
  let(:init_arguments) { [->(_) {}] }
  after { Thread.current[:rf_logger_request_id] = nil }

  context "when tagged is missing" do
    let(:env) { { "X-Request-Id" => "uuid-from_env" } }
    it "defaults to getting the request_id" do
      subject
      expect(Thread.current[:inheritable_attributes][:rf_logger_request_tags]).to eq({ :request_id => "uuid-from_env" })
    end
  end

  context "when tagged option is given that exists" do
    let(:env) { { "X-OtherHeader" => "other_request_id" } }
    let(:init_arguments) { [->(_) {}, tagged: { custom_env_key: "X-OtherHeader" }] }

    it "sets current Thread variable" do
      subject
      expect(Thread.current[:inheritable_attributes][:rf_logger_request_tags]).to eq({ :custom_env_key => "other_request_id" })
    end
  end

  context "when tagged option is given that does not exists" do
    let(:init_arguments) { [->(_) {}, tagged: { custom_env_key: "X-WontFindMe" }] }

    it "sets current Thread variable" do
      subject
      expect(Thread.current[:inheritable_attributes][:rf_logger_request_tags]).to eq({:custom_env_key=>nil})
    end
  end
end
