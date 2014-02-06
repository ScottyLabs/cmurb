require 'spec_helper'

describe CMU::Directory do
  before(:all) do
    @svargo = CMU::Directory.find(:andrew_id=>'svargo').first
    @zhixians = CMU::Directory.find(:name=>'Tom Shen').first
  end

  it 'should fetch a valid user by Andrew ID' do
    @svargo.first_name.should eql('Seth')
    @svargo.last_name.should eql('Vargo')
    @svargo.andrew_id.should eql('svargo')
    @svargo.name.should eql('Seth Vargo')
  end

  it 'should fetch a valid user by full name' do
    @zhixians.first_name.should eql('Tom')
    @zhixians.last_name.should eql('Shen')
    @zhixians.andrew_id.should eql('zhixians')
    @zhixians.name.should eql('Tom Shen')
  end

  it 'should return the user\'s email' do
    @zhixians.email.should eql('tomshen@cmu.edu')
  end

  it 'should return the correct student role' do
    @zhixians.role.should eql('Student')
  end
end