# cmurb

A Ruby library for CMU data. Currently only supports directory.

## Usage
First, `bundle install` all the dependencies. Then, to use the library:

```ruby
>> require './lib/cmu'
>> tom = CMU::Directory.find(:andrew_id=>'zhixians').first
>> tom.name
 => "Tom Shen"
```

You can also search by `:name`, `:first_name` and `:last_name`.
