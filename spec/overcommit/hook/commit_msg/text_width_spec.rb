require 'spec_helper'

describe Overcommit::Hook::CommitMsg::TextWidth do
  let(:config)  { Overcommit::ConfigurationLoader.default_configuration }
  let(:context) { double('context') }
  subject { described_class.new(config, context) }

  before do
    subject.stub(:commit_message_lines).and_return(commit_msg.split("\n"))
  end

  context 'when subject is longer than 60 characters' do
    let(:commit_msg) { 'A' * 61 }

    it { should warn /subject/ }
  end

  context 'when subject is 60 characters or fewer' do
    let(:commit_msg) { 'A' * 60 }

    it { should pass }
  end

  context 'when a line in the message is longer than 72 characters' do
    let(:commit_msg) { <<-MSG }
      Some summary

      This line is longer than 72 characters which is clearly be seen by count.
    MSG

    it { should warn /72 char/ }
  end

  context 'when all lines in the message are fewer than 72 characters' do
    let(:commit_msg) { <<-MSG }
      Some summary

      A reasonable line.

      Another reasonable line.
    MSG

    it { should pass }
  end

  context 'when custom lengths are specified' do
    let(:config) do
      super().merge(Overcommit::Configuration.new(
        'CommitMsg' => {
          'TextWidth' => {
            'max_subject_width' => 70,
            'max_body_width' => 80
          }
        }
      ))
    end

    context 'when subject is longer than 70 characters' do
      let(:commit_msg) { 'A' * 71 }

      it { should warn /subject/ }
    end

    context 'when subject is 70 characters or fewer' do
      let(:commit_msg) { 'A' * 70 }

      it { should pass }
    end

    context 'when a line in the message is longer than 80 characters' do
      let(:commit_msg) { <<-MSG }
        Some summary

        This line is longer than 80 characters which can clearly be seen by counting the number of characters.
      MSG

      it { should warn /80 char/ }
    end

    context 'when all lines in the message are fewer than 80 characters' do
      let(:commit_msg) { <<-MSG }
        Some summary

        A reasonable line.

        Another reasonable line.
      MSG

      it { should pass }
    end
  end
end
