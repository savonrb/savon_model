Savon::Model [![Build Status](https://secure.travis-ci.org/rubiii/savon_model.png)](http://travis-ci.org/rubiii/savon_model)
============

Model for SOAP service oriented applications.


Installation
------------

Savon::Model is available through [Rubygems](http://rubygems.org/gems/savon_model) and can be installed via:

``` bash
$ gem install savon_model
```


Include
-------

Savon::Model comes with quite a few handy class and instance methods for using [Savon](https://github.com/rubiii/savon) inside your SOAP model classes.  
Simply include the module in any of your classes to get started.

``` ruby
require "savon_model"

class User
  include Savon::Model
end
```


Service
-------

You can configure Savon to work with or without a WSDL document with the `.document`, `.endpoint` and `.namespace` class methods.  
Point Savon to the WSDL of your service:

``` ruby
class User
  include Savon::Model

  document "http://service.example.com?wsdl"
end
```

or set the SOAP endpoint and target namespace to bypass the WSDL:

``` ruby
class User
  include Savon::Model

  endpoint "http://service.example.com"
  namespace "http://v1.service.example.com"
end
```


Authentication
--------------

Set your HTTP basic authentication username and password via the `.basic_auth` method:

``` ruby
class User
  include Savon::Model

  basic_auth "login", "password"
end
```

or use the `.wsse_auth` method to set your WSSE username, password and (optional) whether or not to use digest authentication.

``` ruby
class User
  include Savon::Model

  wsse_auth "login", "password", :digest
end
```


Actions
-------

Define the service methods you're working with via the `.actions` class method. Savon::Model creates both class and instance  
methods for every action. These methods accept a SOAP body Hash and return a `Savon::SOAP::Response` for you to use.  
You can wrap those methods in other methods:

``` ruby
class User
  include Savon::Model

  actions :get_user, :get_all_users

  def self.all
    get_all_users.to_array
  end

end
```

or extend them by delegating to `super`:

``` ruby
class User
  include Savon::Model

  actions :get_user, :get_all_users

  def get_user(id)
    super(:user_id => id).to_hash[:get_user_response][:return]
  end

end
```


Else
----

The `Savon::Client` instance used in your model lives at `.client` inside your class. It gets initialized lazily whenever you call  
any other class or instance method that tries to access the client. In case you need to control how the client gets initialized,  
you can pass a block to `.client` before it's memoized:

``` ruby
class User
  include Savon::Model

  client do
    http.headers["Pragma"] = "no-cache"
  end

end
```

You can also bypass Savon::Model and directly use the client:

``` ruby
class User
  include Savon::Model

  document "http://service.example.com?wsdl"

  def find_by_id(id)
    response = client.request(:find_user) do
      soap.body = { :id => id }
    end

    response.body[:find_user_response][:return]
  end

end
```
