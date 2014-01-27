# cmurb

A Ruby library for CMU data. Currently only supports directory.

## Usage
Add `cmu` as a dependency to your `Gemfile`. Then, to use the library:

```ruby
>> require 'cmu'
>> tom = CMU::Directory.find(:andrew_id=>'zhixians').first
>> tom.name
 => "Tom Shen"
```

You can also search by `:name`, `:first_name` and `:last_name`.
