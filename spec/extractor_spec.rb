require 'spec_helper'

describe Divide::Extractor do
  let(:procfile_content) { '' }
  let(:options) { [] }

  before do
    Divide::Extractor.any_instance.stub(:procfile_content).and_return(procfile_content)
    @extractor = Divide::Extractor.new(options)
  end

  context 'without Procfile' do
    it 'returns nil' do
      @extractor.extract_processes!.should be_nil
    end
  end

  context 'with Procfile' do
    let(:procfile_content) { File.read fixture('Procfile') }

    describe 'without options' do
      it 'returns a YAML of unchanged processes' do
        @extractor.extract_processes!.should == {
          'web' => 'bundle exec rails s',
          'worker' => 'bundle exec jobs:work'
        }
      end

      context 'with $PORT in Procfile' do
        let(:procfile_content) { File.read fixture('Procfile_with_port') }

        it 'always overwrite $PORT with default port' do
          @extractor.extract_processes!.should == {
            'web' => 'bundle exec rails s -p 5000',
            'worker' => 'bundle exec jobs:work'
          }
        end
      end
    end

    describe 'with options' do
      let(:procfile_content) { File.read fixture('Procfile_with_flag') }
      let(:options) { [%w(-c ./config.rb)] }

      it 'returns a YAML overwritten processes' do
        @extractor.extract_processes!.should == {
          'web' => 'bundle exec rails s -c ./config.rb',
          'worker' => 'bundle exec jobs:work'
        }
      end

      context 'with non used flags in Procfile' do
        let(:options) { [%w(-key value)] }

        it 'does nothting' do
          @extractor.extract_processes!.should == {
            'web' => 'bundle exec rails s -c PATH_TO_CONFIG',
            'worker' => 'bundle exec jobs:work'
          }
        end
      end
    end
  end
end
