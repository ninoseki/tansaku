# frozen_string_literal: true

require "etc"

RSpec.describe Tansaku::Crawler do
  subject { described_class.new(target_url) }

  include_context "http_server"

  let(:target_url) { "http://#{host}:#{port}" }

  before do
    allow(Tansaku::Path).to receive(:get_by_type).with("all").and_return(["admin.asp"])
  end

  describe "#max_concurrent_requests" do
    it do
      expect(subject.max_concurrent_requests).to eq(Etc.nprocessors * 8)
    end
  end

  context "when not given options" do
    describe "#crawl" do
      it "returns an Array" do
        results = subject.crawl
        expect(results.keys.length).to eq 1
        expect(results.keys.first).to eq("#{target_url}/admin.asp")
        expect(results.values.first).to eq(200)
      end
    end
  end

  context "when given additional list option" do
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

  context "when given headers option" do
    subject {
      described_class.new(target_url, headers: { foo: "bar" })
    }

    describe "#crawl" do
      it do
        results = subject.crawl
        expect(results.keys.length).to eq 1
      end
    end
  end
end
