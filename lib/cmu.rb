require 'net-ldap'

module CMU
  def valid_andrewid?(andrewid)
    not /^[a-zA-Z][a-zA-Z0-9]{1,7}$/.match(andrewid).nil?
  end

  module Directory
    @ldap = Net::LDAP.new(:host => 'ldap.andrew.cmu.edu')

    class Person
      def initialize(data)
        @andrew_id = data[:cmuAndrewId].last
        if data.attribute_names.include?(:nickname)
          @name = data[:nickname].last
        else
          @name = data[:cn].last
        end
        @last_name = data[:sn].last
        @first_name = @name.split()[0]
        if data.attribute_names.include?(:cmupreferredmail)
          @email = data[:cmupreferredmail].last
        else
          @email = data[:mail].last
        end
        if data.attribute_names.include?(:cmupreferredtelephone)
          @phone = data[:cmupreferredtelephone].last.gsub(/[^0-9]/,'')
        else
          @phone = nil
        end
        @role = data[:edupersonaffiliation].last
        if data.attribute_names.include?(:title)
          @title = data[:title].last
        else
          if data.attribute_names.include?(:cmutitle)
            @title = data[:cmutitle].last
          else
            @title = nil
          end
        end
        if data.attribute_names.include?(:cmustudentclass)
          @student_class = data[:cmustudentclass].last
        else
          @student_class = nil
        end
        if data.attribute_names.include?(:cmustudentlevel)
          @student_level = data[:cmustudentlevel].last
        else
          @student_level = nil
        end
        @department = data[:cmudepartment].last
        @affiliated_schools = data[:edupersonschoolcollegename]
      end
      attr_reader :andrew_id, :name, :last_name, :first_name, :email,
      :phone, :role, :title, :student_class, :student_level, :department,
      :affiliated_schools
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