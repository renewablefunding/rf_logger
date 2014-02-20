require 'spec_helper'

describe ErrorNotification::EnvironmentConstraints do
  describe '#included?' do
    it 'returns true if no constraints for :only are given' do
      described_class.new('alpha', {}).included?.should be_true
    end

    it 'returns true if the environment is included in :only' do
      described_class.new('alpha', {:only => ['alpha', 'beta']}).included?.should be_true
    end

    it 'returns false if the environment is not in :only' do
      described_class.new('alpha', {:only => ['beta']}).included?.should be_false
    end
  end

  describe '#excluded?' do
    it 'returns false if no constraints for :except are given' do
      described_class.new('alpha', {}).excluded?.should be_false
    end

    it 'returns true if the environment is included in :except' do
      described_class.new('alpha', {:except => ['alpha', 'beta']}).excluded?.should be_true
    end

    it 'returns false if the environment is not in :except' do
      described_class.new('alpha', {:except => ['beta']}).excluded?.should be_false
    end
  end

  describe '#valid_notifier?' do
    it 'returns true if there are no constraints' do
      described_class.new('alpha', nil).valid_notifier?.should be_true
      described_class.new('alpha', {}).valid_notifier?.should be_true
    end

    it 'returns true if the environment is included in :only and not included in :except' do
      described_class.new('alpha', {:only => ['alpha'], :except => []}).valid_notifier?.should be_true
    end

    it 'returns false if the environment is included in :except' do
      described_class.new('alpha', {:except => ['alpha']}).valid_notifier?.should be_false
    end

    it 'returns false if the environment is not in :only' do
      described_class.new('alpha', {:only => ['beta']}).valid_notifier?.should be_false
    end
  end
end
