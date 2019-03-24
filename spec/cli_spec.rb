# frozen_string_literal: true

RSpec.describe Tansaku::CLI do
  include_context "http_server"

  subject { Tansaku::CLI }

  let(:target_url) { "http://#{host}:#{port}" }

  describe "#crawl" do
    before {
      allow(Tansaku::Crawler).to receive_message_chain(:new, :crawl).and_return(["http://localhost/test"])
    }

    it "should output to STDIN" do
      output = capture(:stdout) { subject.start ["crawl", target_url] }
      expect(output).to include("http://localhost/test")
    end
  end
end
