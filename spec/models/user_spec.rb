require 'rails_helper'
require_relative 'shared_examples'

RSpec.shared_examples "an invalid User" do
  let(:model) { user }
  include_examples "an invalid ActiveRecord"
end

RSpec.describe User, type: :model do
  let(:nickname) { "flubber123" }
  let(:user)   { User.new(nickname: nickname) }

  context "with alphanumeric nickname" do
    it "is #valid?" do
      expect(user).to be_valid
    end
  end

  context "with space in name" do
    let(:nickname) { "1337 haxor" }
    it_behaves_like "an invalid User"
  end

  context "with punctuation in the name" do
    let(:nickname) { "haxor!" }
    it_behaves_like "an invalid User"
  end

  context "dropping a newline at the start" do
    let(:nickname) { "\nhaxor" }
    it_behaves_like "an invalid User"
  end

  context "dropping a newline at the end" do
    let(:nickname) { "haxor\n" }
    it_behaves_like "an invalid User"
  end

  context "when there is contentsion over a nickname" do
    before { User.create!(nickname: nickname) }
    it_behaves_like "an invalid User"
  end
end
