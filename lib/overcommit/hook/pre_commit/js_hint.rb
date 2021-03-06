module Overcommit::Hook::PreCommit
  # Runs `jshint` against any modified JavaScript files.
  class JsHint < Base
    def run
      unless in_path?('jshint')
        return :warn, 'jshint not installed -- run `npm install -g jshint`'
      end

      result = execute(%w[jshint] + applicable_files)
      output = result.stdout

      return :good if output.empty?

      [:bad, output]
    end
  end
end
