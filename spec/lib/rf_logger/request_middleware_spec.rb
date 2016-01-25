require "rf_logger/request_middleware"

RSpec.describe RfLogger::RequestMiddleware do
  subject { RfLogger::RequestMiddleware.new(*init_arguments).call({}) }
  let(:init_arguments) { [->(_) {}] }
  after { Thread.current[:rf_logger_request_id] = nil }

  context "Rails" do
    before { stub_const("ActionDispatch::Request", double("ActionDispatch::Request", new: double("ActionDispatch::Request#", uuid: "uuid-from_env"))) }
    context "when env responds to uuid" do
      it "sets current Thread variable" do
        subject
        expect(Thread.current[:inheritable_attributes][:rf_logger_request_tags]).to eq({ :request_id => "uuid-from_env" })
      end
    end

    context "from custom_env_key" do
      let(:init_arguments) { [->(_) {}, tagged: { custom_env_key: "other_request_id" }] }
      before { stub_const("ActionDispatch::Request", double("ActionDispatch::Request", new: double("ActionDispatch::Request#", other_request_id: "other_request_id"))) }

      it "sets current Thread variable" do
        subject
        expect(Thread.current[:inheritable_attributes][:rf_logger_request_tags]).to eq({ :custom_env_key => "other_request_id" })
      end
    end
  end

  context "Rory" do
    before { stub_const("Rory::Request", double("Rory::Request", new: double("Rory::Request#", uuid: "uuid-from_env"))) }
    context "when env responds to uuid" do
      it "sets current Thread variable" do
        subject
        expect(Thread.current[:inheritable_attributes][:rf_logger_request_tags]).to eq({ :request_id => "uuid-from_env" })
      end
    end

    context "from custom_env_key" do
      let(:init_arguments) { [->(_) {}, tagged: { custom_env_key: "other_request_id" }] }
      before { stub_const("ActionDispatch::Request", double("ActionDispatch::Request", new: double("ActionDispatch::Request#", other_request_id: "other_request_id"))) }

      it "sets current Thread variable" do
        subject
        expect(Thread.current[:inheritable_attributes][:rf_logger_request_tags]).to eq({ :custom_env_key => "other_request_id" })
      end
    end
  end

  context "Other Framework Context" do
    context "when env responds to uuid" do
      let(:init_arguments) { [->(_) {}, rack_request_class: double("rack_request_class", new: double("rack_request_class#", uuid: "uuid-from_env"))] }
      it "sets current Thread variable" do
        subject
        expect(Thread.current[:inheritable_attributes][:rf_logger_request_tags]).to eq({ :request_id => "uuid-from_env" })
      end
    end

    context "from custom_env_key" do
      let(:init_arguments) { [->(_) {}, tagged: { custom_env_key: "other_request_id" }, rack_request_class: double("rack_request_class", new: double("rack_request_class#", other_request_id: "other_request_id"))] }

      it "sets current Thread variable" do
        subject
        expect(Thread.current[:inheritable_attributes][:rf_logger_request_tags]).to eq({ :custom_env_key => "other_request_id" })
      end
    end

    context "when rack_request_class is not given" do
      let(:init_arguments) { [->(_) {}] }

      it "sets current Thread variable" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end
end
