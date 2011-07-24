require "spec_helper"
require "savon/model"

describe Savon::Model do
  let(:model) { Class.new { include Savon::Model } }

  describe ".handle_response" do
    before(:all) { model.actions :get_user, "GetAllUsers" }

    it "should be used for pre-processing SOAP responses" do
      Savon::Model.handle_response = lambda { |response| response }

      model.client.stubs(:request).returns("response")
      model.get_user.should == "response"
    end
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

  describe ".document" do
    it "should set WSDL document" do
      model.document "http://example.com/?wsdl"
      model.client.wsdl.document.should == "http://example.com/?wsdl"
    end
  end

  describe ".basic_auth" do
    it "should set HTTP Basic auth credentials" do
      model.basic_auth "login", "password"
      puts model.client.http.auth.basic.should == ["login", "password"]
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

  describe "#endpoint" do
    it "should delegate to .endpoint" do
      model.expects(:endpoint).with("http://example.com")
      model.new.endpoint "http://example.com"
    end
  end

  describe "#namespace" do
    it "should delegate to .namespace" do
      model.expects(:namespace).with("http://v1.example.com")
      model.new.namespace "http://v1.example.com"
    end
  end

  describe "overwriting action methods" do
    context "(class-level)" do
      let :supermodel do
        supermodel = model.dup
        supermodel.actions :get_user

        def supermodel.get_user(body = nil, &block)
          p "super"
          super
        end

        supermodel
      end

      it "should be possible" do
        supermodel.client.expects(:request).with(:wsdl, :get_user, :body => { :id => 1 })
        supermodel.expects(:p).with("super")  # stupid, but works

        supermodel.get_user :id => 1
      end
    end

    context "(instance-level)" do
      let :supermodel do
        supermodel = model.dup
        supermodel.actions :get_user
        supermodel = supermodel.new

        def supermodel.get_user(body = nil, &block)
          p "super"
          super
        end

        supermodel
      end

      it "should be possible" do
        supermodel.client.expects(:request).with(:wsdl, :get_user, :body => { :id => 1 })
        supermodel.expects(:p).with("super")  # stupid, but works

        supermodel.get_user :id => 1
      end
    end
  end

end
