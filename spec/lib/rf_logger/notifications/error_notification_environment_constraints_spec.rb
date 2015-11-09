require 'spec_helper'

describe RfLogger::ErrorNotification::EnvironmentConstraints do
  describe '#included?' do
    it 'returns true if no constraints for :only are given' do
      expect(described_class.new('alpha', {}).included?).to be(true)
    end

    it 'returns true if the environment is included in :only' do
      expect(
        described_class.new('alpha', {:only => ['alpha', 'beta']}).included?
      ).to be(true)
    end

    it 'returns false if the environment is not in :only' do
      expect(
        described_class.new('alpha', {:only => ['beta']}).included?
      ).to be(false)
    end
  end

  describe '#excluded?' do
    it 'returns false if no constraints for :except are given' do
      expect(described_class.new('alpha', {}).excluded?).to be(false)
    end

    it 'returns true if the environment is included in :except' do
      expect(
        described_class.new('alpha', {:except => ['alpha', 'beta']}).excluded?
      ).to be(true)
    end

    it 'returns false if the environment is not in :except' do
      expect(
        described_class.new('alpha', {:except => ['beta']}).excluded?
      ).to be(false)
    end
  end

  describe '#valid_notifier?' do
    it 'returns true if there are no constraints' do
      expect(described_class.new('alpha', nil).valid_notifier?).to be(true)
      expect(described_class.new('alpha', {}).valid_notifier?).to be(true)
    end

    it 'returns true if the environment is included in :only and not included in :except' do
      expect(
        described_class.new('alpha', {:only => ['alpha'], :except => []}).valid_notifier?
      ).to be(true)
    end

    it 'returns false if the environment is included in :except' do
      expect(
        described_class.new('alpha', {:except => ['alpha']}).valid_notifier?
      ).to be(false)
    end

    it 'returns false if the environment is not in :only' do
      expect(
        described_class.new('alpha', {:only => ['beta']}).valid_notifier?
      ).to be(false)
    end
   end
end
