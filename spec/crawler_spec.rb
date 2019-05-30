# frozen_string_literal: true

RSpec.describe Tansaku::Crawler do
  include_context "http_server"

  let(:target_url) { "http://#{host}:#{port}" }

  before do
    allow(Tansaku::Path).to receive(:get_by_type).with("all").and_return(["admin.asp"])
  end

  context "when not given options" do
    subject { described_class.new(target_url) }

    describe "#online?" do
      it do
        expect(subject.online?("/")).to be false
      end

      it do
        expect(subject.online?("/admin.asp")).to be true
      end
    end

    describe "#crawl" do
      it "returns an Array" do
        results = subject.crawl
        expect(results.length).to eq 1
        expect(results.first).to eq("#{target_url}/admin.asp")
      end
    end
  end

  context "when given options" do
    subject {
      described_class.new(target_url, additional_list: File.expand_path("./fixtures/sample.txt", __dir__))
    }

    before do
      path = File.expand_path("./fixtures/sample.txt", __dir__)
      allow(File).to receive(:readlines).with(path).and_return(["wowee"])
    end

    describe "#crawl" do
      it do
        results = subject.crawl
        expect(results.length).to eq 2
      end
    end
  end
end
