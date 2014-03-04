module Overcommit::Hook::PreCommit
  # Runs `haml-lint` against any modified HAML files.
  class HamlLint < Base
    def run
      unless in_path?('haml-lint')
        return :warn, 'haml-lint not installed -- run `gem install haml-lint`'
      end

      command_string =
        "haml-lint --exclude-lint RubyScript #{applicable_files.join(' ')}"
      result = command(command_string)
      return :good if result.success?

      # Keep lines from the output for files that we actually modified
      error_lines, warning_lines = result.stdout.split("\n").partition do |output_line|
        match = output_line.match(/^([^:]+):(\d+)/)
        if match
          file = match[1]
          line = match[2]
        end
        modified_lines(file).include?(line.to_i)
      end

      return :bad, error_lines.join("\n") unless error_lines.empty?
      return :warn, "Modified files have lints (on lines you didn't modify)\n" <<
                    warning_lines.join("\n")
    end
  end
end
