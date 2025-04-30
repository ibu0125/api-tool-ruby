require 'net/http'
require 'json'

# api接続
class ApiClient
  def initialize(api_uri)
    @api_uri=api_uri

  end

  def fetch_data
    uri=URI(@api_uri)
    res=Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      return JSON.parse(res.body)
    else
      return []
    end
  end
end