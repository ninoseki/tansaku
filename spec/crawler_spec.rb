# frozen_string_literal: true

RSpec.describe Tansaku::Crawler do
  include_context "http_server"

  let(:target_url) { "http://#{host}:#{port}" }

  context "when not given options" do
    subject { Tansaku::Crawler.new(target_url) }
    describe "#online?" do
      context "when accessing to /" do
        it "should return false" do
          expect(subject.online?("/")).to be false
        end
      end
      context "when accessing to /admin.asp" do
        it "should return true" do
          expect(subject.online?("/admin.asp")).to be true
        end
      end
    end
    describe "#crawl" do
      it "should return an Array" do
        results = subject.crawl
        expect(results.length).to eq 1
        expect(results.first).to eq("#{target_url}/admin.asp")
      end
    end
  end

  context "when given options" do
    context "when given additional_list option" do
      subject {
        Tansaku::Crawler.new(target_url, additional_list: File.expand_path("./fixtures/sample.txt", __dir__))
      }
      describe "#crawl" do
        context "when accessing to /wowee" do
          it "should return an Array" do
            results = subject.crawl
            expect(results.length).to eq 2
          end
        end
      end
    end
  end
end
