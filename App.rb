require 'pp'
require_relative './ApiClient.rb'
require_relative './JsonFileManager.rb'
require_relative './DataEditor.rb'

class App
  def initialize
    @json_manager_main=JsonFileManager.new("./json/data.json")
    @json_manager_save=JsonFileManager.new("./json/api_url.json")
    @editer=DataEditor.new
    @api_data=@json_manager_save.read 
    @api_data=[] unless @api_data.is_a?(Array)
    @main_data=@json_manager_main.read
    @data=@main_data.dup

    puts "現在保存されているデータ"
    pp @main_data
    puts "\n\n"
    puts "api接続履歴"
    print_data(@api_data)
  end

  def print_data(data)
    data.each do |d|
      puts "#{d["id"]}: #{d["url"]} <#{d["title"]}>"
    end
  end

  def run
    puts "接続先のapi(url)"
    print ">"
    url=gets.chomp
    puts "apiのタイトル"
    print ">"
    title=gets.chomp

    api_entry={"title" => title,"url"=>url}
    #https://jsonplaceholder.typicode.com/users 
    #https://fakestoreapi.com/products
    @api_client=ApiClient.new(url)
    @json_manager_save.postscript(api_entry)
    loop do
      puts "1.データ取得 2.データの検索 3.key削除 4.data削除 5.jsonに保存 6.api履歴編集 (exitで終了)"
      print ">"
      input=gets.chomp
    
      case input
      when "1"
        fetch_data
      when "2"
        data_search
      when "3"
        delete
      when "4"
        id_delete
      when "5"
        json_save
        break
      when "6"
        api_editor
      when "exit"
        break
      end  
      
      
    end
  end


  def api_editor
    loop do
      puts "<api履歴編集モード>   1.削除 2.title変更 3.終了"
      print ">"
      input=gets.chomp.to_i

      case input
      when 1
        print "削除するid: "
        id=gets.chomp.to_i
        @api_data.delete_if do |data|
          data["id"]==id
        end
        @json_manager_save.write(@api_data)
        print_data(@api_data)

      when 2
        print "編集するid: "
        id=gets.chomp.to_i
        print "新しいtitle: "
        title=gets.chomp

        @api_data.each do |data|
          if data["id"]==id
            data["title"]=title
          end
        end
        @json_manager_save.write(@api_data)
        print_data(@api_data)

      when 3
        break
      end
      
    end
  end

  def fetch_data
    @data=@api_client.fetch_data
    result
  end

  def data_search
    puts "検索したいkeyとvalueを入力してください"
    print "key: "
    key=gets.chomp
    print "value: "
    value=gets.chomp
    @data=@editer.search(@data,key,value)
    result
  end

  def json_save
    @json_manager_main.write(@data)
  end

  def delete
    print "key:"
    key=gets.chomp
    @data=@editer.delete(@data,key)
    result
  end  

  def id_delete
    print "削除したいdataのid: "
    id=gets.chomp.to_i
    @data=@editer.id_delete(@data,id)
    result
  end

  def result
    puts "結果"
    pp @data
  end
end

app=App.new
app.run