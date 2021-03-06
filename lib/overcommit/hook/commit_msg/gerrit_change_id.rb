module Overcommit::Hook::CommitMsg
  # Ensures a Gerrit Change-Id line is included in the commit message.
  #
  # It may seem odd to do this here instead of in a prepare-commit-msg hook, but
  # the reality is that if you want to _ensure_ the Change-Id is included then
  # you need to do it in a commit-msg hook. This is because the user could still
  # edit the message after a prepare-commit-msg hook was run.
  class GerritChangeId < Base
    def run
      result = execute([SCRIPT_LOCATION, commit_message_file])
      return :good if result.success?

      [:bad, result.stdout]
    end

  private

    SCRIPT_LOCATION = Overcommit::Utils.script_path('gerrit-change-id')
  end
end
