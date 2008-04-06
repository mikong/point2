require 'rubygems'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../point2.rb")

class Book
  attr_accessor :title, :no_of_pages
  
  def initialize(title, no_of_pages = 0)
    @title = title
    @no_of_pages = no_of_pages
  end
  
  def to_ary
    [[:title, title], [:no_of_pages, no_of_pages]]
  end
  
  def to_hash
    { :title => title, :no_of_pages => no_of_pages }
  end
end

describe "Point2 Project" do
  
  describe Object do

    it "can try a method" do
      @book.try(:title).should be_nil
      @book = Book.new('Harry Potter')
      @book.try(:title).should eql('Harry Potter')
    end
    
    it "can be tapped" do
      @reversed_and_capitalized =  "dog".reverse.tap {|o| @reversed = o}.capitalize
      @reversed.should == 'god'
      @reversed_and_capitalized.should == 'God'
    end
    
    it "can return a public method" do
      @object = Object.new
      
      # calling a non-existent method
      lambda do
        @object.public_method(:tatata)
      end.should raise_error(NameError)
      
      # calling a private method
      lambda do
        @object.public_method(:format)
      end.should raise_error(NameError)
      
      # calling a public method
      @method = @object.public_method(:class)
      @method.call.should == @object.class
    end
    
    it "can __send__ *args to a public method" do
      @object = Object.new
      
      # send to a private method
      lambda do
        @object.public_send(:format)
      end.should raise_error(NoMethodError)
      
      @object.public_send(:class).should == @object.class
    end
  end
  
  describe Array do
    
    before :each do
      @book = Book.new('My Book', 25)
    end
    
    it "should be able to try to convert an object to array" do
      Array.try_convert(@book).should == [[:title, 'My Book'], [:no_of_pages, 25]]
    end
    
    it "should be able to flatten an array with a level parameter" do
      @array = [1, [2, 3], [4, [5, 6]], 7, 8]
      @array.flatten.should == [1, 2, 3, 4, 5, 6, 7, 8]
      @array.flatten(-1).should == [1, 2, 3, 4, 5, 6, 7, 8]
      @array.flatten(0).should == [1, [2, 3], [4, [5, 6]], 7, 8]
      @array.flatten(1).should == [1, 2, 3, 4, [5, 6], 7, 8]
      @array.flatten(2).should == [1, 2, 3, 4, 5, 6, 7, 8]
      
      # bang! method
      @array.flatten!(1)
      @array.should == [1, 2, 3, 4, [5, 6], 7, 8]
    end
    
  end
  
  describe Hash do
    
    # NOTE: Ruby 1.8 Hash doesn't remember the order of its elements
    
    before :each do
      @hash = { :books => ['Book 1', 'Book 2', 'Book 3'], :reading_glasses => 1 }
      @book = Book.new('My Book', 25)
    end
    
    it "should be able to try to convert an object to hash" do
      Hash.try_convert(@book).should == { :title => 'My Book', :no_of_pages => 25 }
    end
    
    it "should be able to produce a flattened array" do
      @hash.flatten.should == [ :books, 'Book 1', 'Book 2', 'Book 3', :reading_glasses, 1 ]
      @hash.flatten(1).should == [ :books, ['Book 1', 'Book 2', 'Book 3'], :reading_glasses, 1 ]
    end
    
  end
  
  describe Time do
    
    before :each do
      @time = Time.utc(2008, "apr", 1)
    end
    
    it "should confirm it's weekday" do
      @time.tuesday?.should be_true
      @time.sunday?.should be_false
    end
    
  end
  
end
