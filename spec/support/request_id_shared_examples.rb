RSpec.shared_context "RfLogger::RequestId" do |subject:|
  describe "#rf_logger_request_tags" do
  before {allow(subject).to receive(:rf_logger_request_tags).and_call_original}
    context "When thread var inheritable_attributes is nil" do
      before { Thread.current[:inheritable_attributes] = nil }
      it { expect(subject.rf_logger_request_tags).to eq({}) }
    end

    context "when thread var inheritable_attributes is empty hash" do
      before { Thread.current[:inheritable_attributes] = {} }
      it { expect(subject.rf_logger_request_tags).to eq({}) }
    end

    context "when thread var inheritable_attributes has key rf_logger_request_tags" do
      before { Thread.current[:inheritable_attributes] = { rf_logger_request_tags: { hello: "goodbye" } } }
      it { expect(subject.rf_logger_request_tags).to eq({ hello: "goodbye" }) }
    end

    before { Thread.current[:inheritable_attributes] = nil }
  end
end
