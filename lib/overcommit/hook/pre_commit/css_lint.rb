module Overcommit::Hook::PreCommit
  # Runs `csslint` against any modified CSS files.
  class CssLint < Base
    def run
      unless in_path?('csslint')
        return :warn, 'csslint not installed -- run `npm install -g csslint`'
      end

      result = execute(%w[csslint --quiet --format=compact] + applicable_files)
      return :good if result.stdout !~ /Error - (?!Unknown @ rule)/

      [:bad, result.stdout]
    end
  end
end
