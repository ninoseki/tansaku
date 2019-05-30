# frozen_string_literal: true

RSpec.describe Tansaku::Path do
  subject { described_class.new }

  describe "#get_by_type" do
    it do
      expect { subject.get_by_type "undefined type" }.to raise_error(ArgumentError)
    end

    it do
      %w(admin backup database etc).each do |type|
        paths = subject.get_by_type(type)
        expect(paths).to be_an(Array)
      end
    end

    it do
      paths = subject.get_by_type("all")
      expect(paths).to be_an(Array)
    end
  end
end
