require "rf_logger/rails/rails_compatibility"

RSpec.describe RfLogger::RailsCompatibility do

  let(:rails_gem_version) { Gem::Version.new(rails_version) }
  subject { described_class.new(rails_version: rails_gem_version) }

  context "far left" do
    let(:rails_version) { 2.9 }
    it { expect { |b| subject.call(&b) }.to_not yield_control }
  end

  context "edge left" do
    let(:rails_version) { 3.1 }
    it { expect { |b| subject.call(&b) }.to_not yield_control }
  end

  context "middle edge left" do
    let(:rails_version) { 3.2 }
    it { expect { |b| subject.call(&b) }.to yield_control }
  end

  context "center edge" do
    let(:rails_version) { 4.0 }
    it { expect { |b| subject.call(&b) }.to yield_control }
  end

  context "middle edge right" do
    let(:rails_version) { "5.0.10" }
    it { expect { |b| subject.call(&b) }.to yield_control }
  end

  context "edge right" do
    let(:rails_version) { 5.1 }
    it { expect { |b| subject.call(&b) }.to_not yield_control }
  end

  context "far right" do
    let(:rails_version) {6.0}
    it { expect { |b| subject.call(&b) }.to_not yield_control }
  end
end
