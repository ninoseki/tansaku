# frozen_string_literal: true

RSpec.describe Tansaku::CLI do
  subject { described_class }

  include_context "http_server"

  let(:target_url) { "http://#{host}:#{port}" }

  describe "#crawl" do
    before {
      allow(Tansaku::Crawler).to receive_message_chain(:new, :crawl).and_return(["http://localhost/test"])
    }

    it "outputs to STDIN" do
      output = capture(:stdout) { subject.start ["crawl", target_url] }
      expect(output).to include("http://localhost/test")
    end
  end

  describe ".exit_on_failure?" do
    it do
      expect(described_class.exit_on_failure?).to eq(true)
    end
  end
end
