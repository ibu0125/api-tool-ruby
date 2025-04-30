require 'json'

#jsonfile操作
class JsonFileManager
  def initialize(file_path)
    @file_path=file_path
  end


  def postscript(data)
    exist_data=read
    exist_data=[] unless exist_data.is_a?(Array)


    unless 
      exist_data.any? {|d| d["url"]==data["url"]}
      max_id=exist_data.map do |d| 
        d["id"]||0
      end.max||0

      data["id"]=max_id+1
      exist_data << data
      write(exist_data)
    end

         
  end

  def write(data)
    File.open(@file_path,'w') do |file|
      file.puts (JSON.pretty_generate(data)) 
    end
  end

  def read
    json_data=[]

    if !File.exist?(@file_path)
      File.open(@file_path,'w+'){}
    end

    File.open(@file_path,'r') do |file|
      content=file.read

      begin
        return json_data=JSON.parse(content) unless content.strip.empty?
      rescue JSON::ParserError
        puts "json形式ではありませんでした"
        return json_data
      end
    end
  end
end

