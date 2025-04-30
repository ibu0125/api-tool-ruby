#data編集
class DataEditor
  def serch(data,key,value)
    serch_data=data.select do |user|
      data_value=nest_serch(user,key)
      data_value.is_a?(String)&& data_value.include?(value)
    end

    return serch_data
  end

  def nest_search(hash,doted_key)
    keys=doted_key.split(".")
    keys.reduce(hash) do |h,k|
      h.is_a?(Hash) ? h[k] : nil
    end
  end

  def delete(data,key)
    data.each do |user|
      keys=key.split(".")
      if keys.length==1
        user.delete(key)
      else
        last_key=keys.pop
        target=keys.reduce(user) do |h,k|
          h.is_a?(Hash) ? h[k] : nil
        end

        target.delete(last_key)
      end
    end

    return data
  end


  def id_delete(data,id)
    return data.reject {|user| user["id"]==id}
  end

end

