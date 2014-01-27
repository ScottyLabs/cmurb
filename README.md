# cmurb

A Ruby library for CMU data. Currently only supports directory.

## Usage
```ruby
>> require 'cmu'
>> tom = CMU::Directory.find(:andrew_id=>'zhixians').first
>> tom.name
 => "Tom Shen"
