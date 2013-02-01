class PublisherImporter
  
  def self.import(file_name , publisher_name)

    @publisher = Publisher.find_by_name(publisher_name) || create_publisher(publisher_name)

    @line_number = 0
    extract_file(file_name).each_line { |line| insert_deal(line) }
  end

  private

  def self.extract_file(file_name)

    file = File.new(file_name, "r")
    contents = file.read
    file.close

    contents
  end
  
  def self.insert_deal(line)
    begin

      if @line_number != 0
        @advertiser = Advertiser.find_by_name(parse_name(line)) || create_advertiser(line)
        
        create_deal(line)
      end
      
      @line_number += 1
      
    rescue ActiveRecord::RecordInvalid 
      puts "error importing line: #{@line_number}"
    end
    
  end

  def self.create_publisher(publisher_name)
    
    Publisher.new.tap do |publisher|
      publisher.name = publisher_name
      publisher.save!
    end
    
  end

  def self.create_advertiser(line)

    Advertiser.new.tap do |advertiser|
      advertiser.publisher = @publisher
      advertiser.name = @advertiser.name
      advertiser.save!
    end
    
  end

  def self.create_deal(line)
    
    Deal.new.tap do |deal|
      deal.advertiser = @advertiser
      deal.description = parse_description(line)
      deal.value = parse_value(line)
      deal.price = parse_price(line)
      deal.start_at = parse_start_date(line)
      deal.end_at = parse_end_date(line)
      deal.save!
    end
    
  end

  def self.parse_description(line)
    line.split(" ").drop_while {|str| !str.include? "/"}.
      drop_while {|str| str.include? "/"}.
      take_while {|str| str.to_i == 0}.join(" ")
  end

  def self.parse_value(line)
    line.split(" ").last.to_i
  end

  def self.parse_price(line)
    line.split(" ")[-2].to_i
  end

  def self.parse_start_date(line)
    convert_to_date(*line.split(" ").drop_while {|str| !str.include? "/"}.first.split("/").map(&:to_i))
  end

  def self.parse_end_date(line)
    convert_to_date(*line.split(" ").drop_while {|str| !str.include? "/"}.second.split("/").map(&:to_i))
  end

  def self.convert_to_date(month,day,year)
    DateTime.new(year,month,day,0,0,0)
  end
  
  def self.parse_name(line)
    name = line.split(" ").take_while{ |str| !str.include? "/"}.join(" ")
  end
  
end