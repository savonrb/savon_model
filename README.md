Savon::Model
============

Model for SOAP service oriented applications.

[Bugs](http://github.com/rubiii/savon_model/issues) | [Docs](http://rubydoc.info/gems/savon_model/frames)

Installation
------------

The gem is available through [Rubygems](http://rubygems.org/gems/savon_model) and can be installed via:

    $ gem install savon_model

Getting started
---------------

    class User
      include Savon::Model

      client do                                               [1]
        http.headers["Pragma"] = "no-cache"
      end

      document "http://example.com/users?wsdl"                [2.0]
      basic_auth "login", "password"                                   [2.1]
      endpoint "http://example.com/users"                          [2.2]
      namespace "http://v1.example.com/users"                  [3]

      actions :get_user, :get_all_users                       [4]

      def self.all
        get_all_users.to_array                                [5]
      end

      def self.find(id)
        get_user(:id => id).to_hash                           [6]
      end

      def self.delete(id)
        client.request(:delete_user) do                       [7]
          soap.body = { :id => 1 }
        end.to_hash
      end
    end

1. You can call the `client` method with a block of settings to be passed to `Savon::Client.new`.
   The `client` method memoizes a `Savon::Client` instance, so you need to call this method before
   it gets called by any other method.

2. Sets the SOAP endpoint.

3. Sets the SOAP namespace.

4. Specifies the SOAP actions provided by the service. This method dynamically creates both class
   and instance methods named after the arguments. These methods accept an optional SOAP body Hash
   or XML String to be passed to the `Savon::Client` instance.

5. `User.all` calls the `get_all_users` SOAP action and returns a `Savon::Response`.

6. `User.find` calls the `get_user` SOAP action with a SOAP body Hash and returns a `Savon::Response`.

7. This is an example of what happens "behind the scenes" on [6]. You can always use the `client`
   method to directly access and use the `Savon::Client` instance.
