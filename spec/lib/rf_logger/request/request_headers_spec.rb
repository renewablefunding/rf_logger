require "rf_logger/request/request_headers"
require "thread/inheritable_attributes"

RSpec.describe RfLogger::RequestHeaders do
  before { Thread.current.set_inheritable_attribute(:rf_logger_request_tags, nil) }

  describe "#to_hash" do
    context "when no type is given" do
      it "defaults to json" do
        expect(described_class.new.content_type).to eq "application/json"
        expect(described_class.new.to_hash).to eq({ "Content-Type" => "application/json" })
      end
    end

    context "when providing additional types" do
      it "returns given type" do
        expect(described_class.new(type: "application/xml").content_type).to eq "application/xml"
        expect(described_class.new(type: "application/xml").to_hash).to eq({ "Content-Type" => "application/xml" })
      end
    end

    context "when api_token is not given" do
      it "returns no key or value" do
        expect(described_class.new.api_token).to eq nil
        expect(described_class.new.to_hash).to eq({ "Content-Type" => "application/json" })
      end
    end

    context "when api_token is given" do
      it "returns given token" do
        expect(described_class.new(api_token: "1090").api_token).to eq "1090"
        expect(described_class.new(api_token: "1090").to_hash).to eq({ "Content-Type" => "application/json", "Api-Token" => "1090" })
      end
    end

    context "when request_id is given" do
      it "returns given request_id" do
        expect(described_class.new(request_id: "21090").request_id).to eq "21090"
        expect(described_class.new(request_id: "21090").to_hash).to eq({ "Content-Type" => "application/json", "X-Request-Id" => "21090" })
      end
    end

    context "when request_id is not given" do
      after { Thread.current.set_inheritable_attribute(:rf_logger_request_tags, nil) }

      context "when in the context of a request" do
        before { Thread.current.set_inheritable_attribute(:rf_logger_request_tags, { request_id: "41087" }) }

        it "returns given request_id" do
          expect(described_class.new.request_id).to eq "41087"
          expect(described_class.new.to_hash).to eq({ "Content-Type" => "application/json", "X-Request-Id" => "41087" })
        end
      end

      context "when not in the context of a request" do
        it "returns given request_id" do
          expect(described_class.new.request_id).to eq nil
          expect(described_class.new.to_hash).to eq({ "Content-Type" => "application/json" })
        end
      end
    end

    context "given any additional symbol keys" do
      it "converts them to dashes and uppercases the first letter" do
        expect(described_class.new(accept:      "application/json",
                                   api_version: "2.1").to_hash).
          to eq({ "Content-Type" => "application/json", "Accept" => "application/json", "Api-Version" => "2.1" })
      end
    end

    context "given the key of other" do
      it "leaves the key name as is" do
        expect(described_class.new(other: { "API_Version" => "10" }).to_hash).
          to eq({ "Content-Type" => "application/json", "API_Version" => "10" })
      end

      it "excludes any key values where the values is nil" do
        expect(described_class.new(other: { "API_Version" => nil }).to_hash).
          to eq({ "Content-Type" => "application/json" })
      end
    end
  end
end
