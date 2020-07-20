# frozen_string_literal: true

RSpec.describe Tansaku::Crawler do
  include_context "http_server"

  let(:target_url) { "http://#{host}:#{port}" }

  before do
    allow(Tansaku::Path).to receive(:get_by_type).with("all").and_return(["admin.asp"])
  end

  context "when not given options" do
    subject { described_class.new(target_url) }

    describe "#crawl" do
      it "returns an Array" do
        results = subject.crawl
        expect(results.keys.length).to eq 1
        expect(results.keys.first).to eq("#{target_url}/admin.asp")
        expect(results.values.first).to eq(200)
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
        expect(results.keys.length).to eq 2
      end
    end
  end
end
