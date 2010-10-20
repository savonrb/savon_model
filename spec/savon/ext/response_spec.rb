require "spec_helper"
require "savon/ext/response"

describe Savon::SOAP::Response do
  let(:response) { Savon::SOAP::Response.new http_response(:authentication) }
  let(:users_response) { Savon::SOAP::Response.new http_response(:users) }

  describe "#original_hash" do
    it "should return the original Hash" do
      response.original_hash[:authenticate_response].should be_a(Hash)
    end
  end

  describe "#to_hash" do
    it "should memoize the result" do
      response.to_hash.should equal(response.to_hash)
    end

    context "without response pattern" do
      it "should return the original Hash" do
        response.to_hash[:authenticate_response].should be_a(Hash)
      end
    end

    context "with response pattern" do
      around do |example|
        Savon::Model.response_pattern = [/.+_response/, :return]
        example.run
        Savon::Model.response_pattern = nil
      end

      it "should apply the response pattern" do
        response.to_hash[:success].should be_true
      end
    end

    context "with unmatched response pattern" do
      around do |example|
        Savon::Model.response_pattern = [:unmatched, :pattern]
        example.run
        Savon::Model.response_pattern = nil
      end

      it "should apply the response pattern" do
        response.to_hash.should be_nil
      end
    end
  end

  describe "#to_array" do
    around do |example|
      Savon::Model.response_pattern = [/.+_response/, :return]
      example.run
      Savon::Model.response_pattern = nil
    end

    it "should return an Array for a single response element" do
      response.to_array.should be_an(Array)
      response.to_array.first[:success].should be_true
    end

    it "should memoize the result" do
      response.to_array.should equal(response.to_array)
    end

    it "should return an Array for multiple response element" do
      users_response.to_array.should be_an(Array)
      users_response.to_array.should have(3).items
    end
  end

  def http_response(fixture)
    HTTPI::Response.new 200, {}, File.read("spec/fixtures/#{fixture}.xml")
  end

end
