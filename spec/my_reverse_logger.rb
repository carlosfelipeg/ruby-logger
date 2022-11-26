# typed: false
require_relative '../logger/my_reverse_logger.rb'

describe MyReverseLogger do
  describe "log different type of messages" do
    it 'writes messages in reverse' do
      expect(MyReverseLogger.new.info('hello world')).to eq('[INFO] dlrow olleh')
      expect(MyReverseLogger.new.warn('a warn')).to eq('[WARN] nraw a')
      expect(MyReverseLogger.new.error('an error')).to eq('[ERROR] rorre na')
    end
  end

  describe "tags support" do
    it 'supports tags in reverse' do
      my_logger = MyReverseLogger.new(warn_size: 1, error_size: 3)
      expect(my_logger.info('api response', tag: 'API Calls')).to eq('[API Calls][INFO] esnopser ipa')
      expect(my_logger.error('test1', tag: 'Test1')).to be_nil
      expect(my_logger.warn('blabla', tag: 'Example')).to eq('[Example][WARN] albalb')
      expect(my_logger.error('test2', tag: 'Test2')).to be_nil
      expect(my_logger.error('test3', tag: 'Test3')).to eq(['[Test1][ERROR] 1tset', '[Test2][ERROR] 2tset', '[Test3][ERROR] 3tset'].join('/n'))
    end
  end
end
