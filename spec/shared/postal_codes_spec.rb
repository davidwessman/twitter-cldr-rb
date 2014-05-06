# encoding: UTF-8

# Copyright 2012 Twitter, Inc
# http://www.apache.org/licenses/LICENSE-2.0

require 'spec_helper'

include TwitterCldr::Shared

describe PostalCodes do
  describe "#territories" do
    let(:territories) { PostalCodes.territories }

    it 'returns an array' do
      territories.should be_instance_of(Array)
    end

    it 'returns symbols' do
      territories.each { |territory| territory.should be_instance_of(Symbol) }
    end

    it 'returns supported territories' do
      territories.should include(:br, :fr, :jp)
    end
  end

  describe "#new" do
    it "should raise an error if the territory isn't supported" do
      lambda { PostalCodes.for_territory(:xx) }.should raise_error(InvalidTerritoryError)
    end

    it 'accepts strings' do
      PostalCodes.for_territory("us").should be_a(PostalCodes)
    end

    it 'accepts upper-case strings' do
      PostalCodes.for_territory("US").should be_a(PostalCodes)
    end
  end

  context "with a PostalCodes instance" do
    let(:postal_code) { PostalCodes.for_territory(:us) }

    describe '#regexp' do
      it 'returns postal code regex for a given territory' do
        postal_code.regexp.should be_a(Regexp)
      end
    end

    describe '#valid?' do
      it 'returns true if a given postal code satisfies the regexp' do
        postal_code.valid?('12345-6789').should be_true
      end

      it "returns false if a given postal code doesn't satisfy the regexp" do
        postal_code.valid?('postal-code').should be_false
      end
    end

    describe "#sample" do
      PostalCodes.territories.each do |territory|
        postal_code = PostalCodes.for_territory(territory)

        it "returns samples that match #{territory}" do
          postal_code.sample(10).each do |sample|
            result = postal_code.valid?(sample)
            puts "Failed with example #{sample}" unless result
            result.should be_true
          end
        end
      end
    end
  end
end
