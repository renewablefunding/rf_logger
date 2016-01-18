RSpec.shared_context "RfLogger::RequestId" do |subject:|
  context "when Thread variable is set" do
    before { Thread.current[:rf_logger_request_id] = "request-uuid-0000-1111" }
    it { expect(subject.request_id).to eq "request-uuid-0000-1111" }
    after { Thread.current[:rf_logger_request_id] = nil }
  end

  context "when Thread variable is not set" do
    before { Thread.current[:rf_logger_request_id] = nil }
    it { expect(subject.request_id).to eq "uninitialized" }
  end
end
