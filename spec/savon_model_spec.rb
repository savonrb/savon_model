require "spec_helper"

describe Savon::Model do

  describe ".client" do
    before(:all) do
      @client = User.client :user_service,
        :endpoint => "http://example.com",
        :namespace => "http://user_service.example.com"
    end

    it "should store Savon::Client objects for a given name and options" do
      @client.should be_a(Savon::Client)
    end

    it "should set the endpoint specified through the Hash of options" do
      @client.request.endpoint.should == URI("http://example.com")
    end

    it "should set the namespace specified through the Hash of options" do
      Savon::SOAP.namespaces["xmlns:wsdl"].should == "http://user_service.example.com"
    end

    it "should return the Savon::Client stored under a certain name" do
      User.client(:user_service).should be_a(Savon::Client)
    end
  end

  describe "#client" do
    it "should return the Savon::Client stored under a certain name" do
      User.client :user_service,
        :endpoint => "http://example.com",
        :namespace => "http://user_service.example.com"
      
      User.new.client(:user_service).should be_a(Savon::Client)
    end
  end

  describe "initialize" do
    it "should accept a Hash of attributes and assign them to instance variables" do
      user = User.new :id => 1, :name => "Eve", :email => "eve@example.com"
      
      user.id.should == 1
      user.name.should == "Eve"
      user.email.should == "eve@example.com"
    end
  end

end
