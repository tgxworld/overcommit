module Overcommit::Hook::PostCheckout
  # If Gemfile dependencies were modified since HEAD was changed, check if
  # currently installed gems satisfy the dependencies.
  class BundleCheck < Base
    def run
      unless in_path?('bundle')
        return :warn, 'bundler not installed -- run `gem install bundler`'
      end

      return :warn if dependencies_changed? && !dependencies_satisfied?

      :good
    end

  private

    def dependencies_changed?
      result = execute(%w[git diff --exit-code --name-only] + [new_head, previous_head])

      result.stdout.split("\n").any? do |file|
        Array(@config['include']).any? { |glob| File.fnmatch(glob, file) }
      end
    end

    def dependencies_satisfied?
      execute(%w[bundle check]).success?
    end
  end
end
