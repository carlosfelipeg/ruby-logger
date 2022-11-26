# typed: false
require_relative '../logger/my_logger.rb'

describe MyLogger do
  describe "log different type of messages" do
    it 'supports info' do
      expect(MyLogger.new.info('hello world')).to eq('[INFO] hello world')
     end
     it 'supports warn' do
      expect(MyLogger.new.warn('this is a warning')).to eq('[WARN] this is a warning')
     end
     it 'supports error' do
      expect(MyLogger.new.error('this is an error')).to eq('[ERROR] this is an error')
     end
  end

  describe "warn size and error size" do
    it 'supports buffered output' do
      my_logger = MyLogger.new(warn_size: 2, error_size: 3)
      expect(my_logger.info('hello')).to eq('[INFO] hello')
      expect(my_logger.warn('blabla')).to be_nil
      expect(my_logger.warn('umbrella')).to eq(['[WARN] blabla', '[WARN] umbrella'].join('/n'))
      expect(my_logger.warn('hello')).to be_nil
      expect(my_logger.error('oops')).to be_nil
      expect(my_logger.error('oopsie')).to be_nil
      expect(my_logger.warn('what')).to eq(['[WARN] hello', '[WARN] what'].join('/n'))
      expect(my_logger.error('ouch')).to eq(['[ERROR] oops', '[ERROR] oopsie', '[ERROR] ouch'].join('/n'))
     end
  end

  describe "tags support" do
    it 'supports tags' do
      my_logger = MyLogger.new(warn_size: 1, error_size: 3)
      expect(my_logger.info('api response', tag: 'API Calls')).to eq('[API Calls][INFO] api response')
      expect(my_logger.error('test1', tag: 'Test1')).to be_nil
      expect(my_logger.warn('blabla', tag: 'Example')).to eq('[Example][WARN] blabla')
      expect(my_logger.error('test2', tag: 'Test2')).to be_nil
      expect(my_logger.error('test3', tag: 'Test3')).to eq(['[Test1][ERROR] test1', '[Test2][ERROR] test2', '[Test3][ERROR] test3'].join('/n'))
    end
  end
end
