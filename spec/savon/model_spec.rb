require "spec_helper"
require "savon/model"

describe Savon::Model do
  let :model do
    Class.new { include Savon::Model }
  end

  describe ".client" do
    it "should should pass a given block to a new Savon::Client"

    it "should memoize the Savon::Client" do
      model.client.should equal(model.client)
    end
  end

  describe ".endpoint" do
    it "should set the SOAP endpoint" do
      model.endpoint "http://example.com"
      model.client.wsdl.endpoint.should == "http://example.com"
    end
  end

  describe ".namespace" do
    it "should set the target namespace" do
      model.namespace "http://v1.example.com"
      model.client.wsdl.namespace.should == "http://v1.example.com"
    end
  end

  describe ".actions" do
    before(:all) { model.actions :get_user, "GetAllUsers" }

    it "should define class methods each action" do
      model.should respond_to(:get_user, :get_all_users)
    end

    it "should define instance methods each action" do
      model.new.should respond_to(:get_user, :get_all_users)
    end

    context "(class-level)" do
      it "should execute SOAP requests with a given body" do
        model.client.expects(:request).with(:wsdl, :get_user, :body => { :id => 1 })
        model.get_user :id => 1
      end

      it "should accept and pass Strings for action names" do
        model.client.expects(:request).with(:wsdl, "GetAllUsers", :body => { :id => 1 })
        model.get_all_users :id => 1
      end
    end

    context "(instance-level)" do
      it "should delegate to the corresponding class method" do
        model.expects(:get_all_users).with(:active => true)
        model.new.get_all_users :active => true
      end
    end
  end

  describe "#client" do
    it "should return the class-level Savon::Client" do
      model.new.client.should == model.client
    end
  end

end
