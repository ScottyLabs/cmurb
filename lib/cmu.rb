require 'net-ldap'

module CMU
  def valid_andrewid?(andrewid)
    not /^[a-zA-Z][a-zA-Z0-9]{1,7}$/.match(andrewid).nil?
  end

  module Directory
    @ldap = Net::LDAP.new(:host => 'ldap.andrew.cmu.edu')

    class Person
      def initialize(data)
        @data = {}
        @data[:andrew_id] = data[:cmuAndrewId].last
        if data.attribute_names.include?(:nickname)
          @data[:name] = data[:nickname].last
        else
          @data[:name] = data[:cn].last
        end
        @data[:last_name] = data[:sn].last
        @data[:first_name] = @data[:name].split()[0]
        if data.attribute_names.include?(:cmupreferredmail)
          @data[:email] = data[:cmupreferredmail].last
        else
          @data[:email] = data[:mail].last
        end
        if data.attribute_names.include?(:cmupreferredtelephone)
          @data[:phone] = data[:cmupreferredtelephone].last.gsub(/[^0-9]/,'')
        else
          @data[:phone] = nil
        end
        @data[:role] = data[:edupersonaffiliation].last
        if data.attribute_names.include?(:title)
          @data[:title] = data[:title].last
        else
          if data.attribute_names.include?(:cmutitle)
            @data[:title] = data[:cmutitle].last
          else
            @data[:title] = nil
          end
        end
        if data.attribute_names.include?(:cmustudentclass)
          @data[:student_class] = data[:cmustudentclass].last
        else
          @data[:student_class] = nil
        end
        if data.attribute_names.include?(:cmustudentlevel)
          @data[:student_level] = data[:cmustudentlevel].last
        else
          @data[:student_level] = nil
        end
        @data[:department] = data[:cmudepartment].last
        @data[:affiliated_schools] = data[:edupersonschoolcollegename]
      end

      def method_missing(name, *args, &blk)
        if args.empty? && blk.nil? && @data.has_key?(name)
          @data[name]
        else
          super
        end
      end

      attr_reader :data
    end

    def Directory.search(query)
      data = @ldap.search(:base => 'ou=Person,dc=cmu,dc=edu', :filter => query)
      data.nil? ? [] : data
    end

    def Directory.search_by_name(name)
      nickname_filter = Net::LDAP::Filter.contains('nickname', name)
      givenname_filter = Net::LDAP::Filter.contains('cn', name)
      Directory.search(nickname_filter).concat(Directory.search(givenname_filter))
    end

    def Directory.find(args)
      if args.key?(:andrew_id)
        data = Directory.search('cmuAndrewId=' + args[:andrew_id])
      elsif args.key?(:first_name)
        data = Directory.search_by_name(args[:first_name])
      elsif args.key?(:last_name)
        data = Directory.search_by_name(args[:last_name])
      elsif args.key?(:name)
        data = Directory.search_by_name(args[:name])
      else
        data = nil
      end
      data.map { |person_hash| Directory::Person.new(person_hash) }
    end
  end
end