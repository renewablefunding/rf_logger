require "rf_logger/request/request_middleware"
require "thread/inheritable_attributes"

RSpec.describe RfLogger::RequestMiddleware do
  subject { RfLogger::RequestMiddleware.new(*init_arguments).call(env) }
  let(:env) { {} }
  let(:init_arguments) { [->(_) {}] }
  let(:rf_logger_request_tags) { Thread.current.get_inheritable_attribute(:rf_logger_request_tags) || :tags_not_present }

  before do
    Thread.current.set_inheritable_attribute(:rf_logger_request_tags, nil)
  end

  context "when tagged: keyword arg is not given it loads defaults" do
    before { subject }
    context "when env[/request_id/] is present" do
      let(:env) { { "some_other_env"     => "other_value",
                    "sinatra.request_id" => "framework_request_id_value",
                    "X-Request-Id"       => "http_request_id_value" } }
      it { expect(rf_logger_request_tags).to eq({ :request_id => "framework_request_id_value" }) }
    end

    context "when env['X-Request-Id'] is the only value" do
      let(:env) { { "X-Request-Id" => "http_request_id_value", "some_other_env" => "other_value" } }
      it { expect(rf_logger_request_tags).to eq({ :request_id => "http_request_id_value" }) }
    end

    context "when env[/request_id/] os env['X-Request-Id'] NOT is present" do
      let(:env) { {} }

      it "is not set in the tags" do
        expect(rf_logger_request_tags).to eq({})
      end
    end
  end

  context "when tagged: keyword arg is given" do
    context "when the env exists" do
      before { subject }
      let(:env) { { "some_other_env" => "other_value", "X-OtherHeader" => "other_request_id" } }
      let(:init_arguments) { [->(_) {}, tagged: { custom_env_key: "X-OtherHeader" }] }
      it "sets current Thread variable" do
        expect(rf_logger_request_tags).to eq({ :custom_env_key => "other_request_id" })
      end
    end

    context "when a tagged match type is unknown" do
      let(:env) { { "X-OtherHeader" => "other_request_id", "some_other_env" => "other_value" } }
      let(:init_arguments) { [->(_) {}, tagged: { custom_env_key: [1] }] }

      it "sets current Thread variable" do
        expect { subject }.to raise_error("Unknown tagged match type: 1")
        expect(rf_logger_request_tags).to eq(:tags_not_present)
      end
    end

    context "when the env does not exists" do
      before { subject }
      let(:init_arguments) { [->(_) {}, tagged: { custom_env_key: "X-WontFindMe" }] }

      it "is not set in the tags" do
        expect(rf_logger_request_tags).to eq({})
      end
    end
  end
end
