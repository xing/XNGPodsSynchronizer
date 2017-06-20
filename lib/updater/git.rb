class Git
  attr_accessor :path

  def initialize(path = Dir.pwd)
    @path = path
  end

  def commit(message)
    execute('git add', '--all')
    execute('git commit', '-m', "'#{message}'")
  end

  def push(remote = 'origin master', options = nil)
    execute('git push', remote, options)
  end

  def clone(url, options = '.')
    execute('git clone', url, options)
  end

  def set_origin(url)
    execute('git remote', 'set-url origin', url)
  end

  def create_github_repo(access_token, org, name, endpoint)
    execute('curl',
    "#{endpoint}/orgs/#{org}/repos?access_token=#{access_token}",
    '-d', "'{\"name\":\"#{name}\"}'")
  end

  private

    def execute(*command)
      FileUtils.mkdir_p(path) unless Dir.exists?(path)
      Dir.chdir(path) do
        system(*command.join(" ").strip)
      end
    end

end
