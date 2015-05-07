describe Version do
  before :all do
    @path_to_version_dir = File.join('spec', 'fixtures', 'specs', 'XNGAPIClient', '1.2.0')
  end

  describe '::new' do
    it 'initializes with a versions dir' do
      version = Version.new(path: @path_to_version_dir)

      expect(version.path).to eql(@path_to_version_dir)
    end
  end

  describe '#podspec_path' do
    it 'gets the corred podspec filepath' do
      version = Version.new(path: @path_to_version_dir)
      expected_path = File.join(@path_to_version_dir, 'XNGAPIClient.podspec.json')
      actual_path = version.send(:podspec_path)
      expect(actual_path).to eql(expected_path)
    end
  end

  describe '#contents' do
    it 'gets the fetches the podspec correctly' do
      version = Version.new(path: @path_to_version_dir)
      expected_contents = {
       "name"=>"XNGAPIClient",
       "version"=>"1.2.0",
       "license"=>"MIT",
       "platforms"=>{"ios"=>"6.0",
       "osx"=>"10.8"}, "summary"=>"The official Objective-C client for the XING API",
       "authors"=>{"XING iOS Team"=>"iphonedev@xing.com"}, "source"=>{"git"=>"https://github.com/xing/XNGAPIClient.git",
       "tag"=>"1.2.0"}, "requires_arc"=>true, "homepage"=>"https://www.xing.com",
       "default_subspecs"=>"Core",
       "subspecs"=>[{"name"=>"Core",
       "source_files"=>"XNGAPIClient/*.{h,m}",
       "dependencies"=>{"SSKeychain"=>["~> 1.2.0"], "XNGOAuth1Client"=>["~> 2.0.0"]}, "frameworks"=>["Security",
       "SystemConfiguration"]}, {"name"=>"NSDictionary-Typecheck",
       "source_files"=>"XNGAPIClient/NSDictionary+Typecheck.{h,m}"}]
     }

      expect(version.contents).to eql(expected_contents)
    end
  end
end