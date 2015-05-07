describe Pod do
  before :all do
    @path_to_podspecs_dir = File.join('spec', 'fixtures', 'specs', 'XNGAPIClient')
  end

  describe '::new' do
    it 'init with podspec dir' do
      class_under_test = Pod.new(path: @path_to_podspecs_dir)
      expect(class_under_test.path).to eql(@path_to_podspecs_dir)
    end
  end

  describe '#name' do
    it 'gets the correct pod name' do
      class_under_test = Pod.new(path: @path_to_podspecs_dir)
      expect(class_under_test.name).to eql("XNGAPIClient")
    end
  end

  describe '#source' do
    it 'gets the correct source url' do
      class_under_test = Pod.new(path: @path_to_podspecs_dir)
      expect(class_under_test.git_source).to eql("https://github.com/xing/XNGAPIClient.git")
    end
  end

  describe '#versions' do
    it 'should return all versions for that pod' do
      class_under_test = Pod.new(path: @path_to_podspecs_dir)
      versions = class_under_test.versions
      expected_versions = [
        '0.1.0', '0.2.0', '0.2.1', '0.2.2', '0.3.0', '0.3.1',
        '0.4.0', '1.0.0', '1.1.0', '1.1.1', '1.2.0'
      ]

      actual_versions = versions.map(&:version)
      expect(actual_versions.sort).to eql(expected_versions.sort)
    end
  end

  describe '#git' do
    it 'should add the pod path as the default git path' do
      class_under_test = Pod.new(path: @path_to_podspecs_dir)
      expect(class_under_test.git.path).to eql(@path_to_podspecs_dir)
    end

    it 'should be able to set a custom path' do
      class_under_test = Pod.new(path: @path_to_podspecs_dir)
      expected_path = "./some/other/path"
      class_under_test.git.path = expected_path
      expect(class_under_test.git.path).to eql(expected_path)
    end
  end
end