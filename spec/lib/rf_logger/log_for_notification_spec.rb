describe RfLogger::LogForNotification do
  subject { described_class.new(
    :actor => 'fruit_cocktail',
    :action => 'finding_maraschino_cherries',
    :level => 'ERROR',
    :metadata => { :something_is_wrong => 'with_the_refrigerator' }
  )}

  before :each do
    RfLogger.configuration.clear!
  end

  describe 'subject' do
    it 'reports log level, actor, and action of the error' do
      subject.subject.should =~ /ERROR.*fruit_cocktail.*finding_maraschino_cherries/
    end

    it 'uses the configured subject, if given' do
      RfLogger.configuration.notification_subject = "Help! {{level}} for {{actor}}/{{action}}"
      subject.subject.should == "Help! ERROR for fruit_cocktail/finding_maraschino_cherries"
    end
  end

  describe 'details' do
    it 'should include metadata' do
      subject.details.should =~ /something_is_wrong.*with_the_refrigerator/
    end
  end
end
