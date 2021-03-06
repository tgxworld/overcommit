module Overcommit::Hook::PreCommit
  # Runs `flake8` against any modified Python files.
  class PythonFlake8 < Base
    def run
      unless in_path?('flake8')
        return :warn, 'flake8 not installed -- run `pip install flake8`'
      end

      result = execute(%w[flake8] + applicable_files)
      return :good if result.success?

      [:bad, result.stdout]
    end
  end
end
