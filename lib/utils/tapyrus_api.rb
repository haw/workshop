class TapyrusApi
  include Singleton

  class FileNotFound < StandardError; end
  class UrlNotFound < StandardError; end

  class << self
    def get_tokens(confirmation_only = true)
      # ワーク1.1.で実装
      return [
        {
          token_id: "** まだ未実装です。機能を実装してください。 **",
          amount: 0
        }

      ]
    end

    def post_tokens_issue(amount:, token_type: 1, split: 1)
      # ワーク1.2.で実装
    end

    def get_addresses(per: 25, page: 1, purpose: "general")
      # ワーク1.3.で実装
      return {
        "addresses": ["** まだ未実装です。機能を実装してください。 **", "** 未実装です。機能を実装してください。 **"],
        "count": 2
      }
    end

    def post_addresses(purpose: "general")
      # ワーク1.4.で実装
    end

    def put_tokens_transfer(token_id, address:, amount:)
      # ワーク1.5.で実装
    end

    def get_userinfo(confirmation_only = true)
      # http://localhost:3000 で使用している。
      # 応用編として実装してみよう。
      return {
        sub: "** まだ未実装です。機能を実装してください。 **",
        addresses: ["** まだ未実装です。機能を実装してください。 **"]
      }
    end

    def get_timestamps
      # Additional Task で実装
    end

    def get_timestamp(id)
      # Additional Task で実装
    end

    def post_timestamp(content:, digest:, prefix:, type:)
      # Additional Task で実装
    end
  end

  attr_reader :connection, :access_token, :url

  def initialize
    @access_token = ENV['ACCESS_TOKEN']
    @url = ENV['TAPYRUS_API_ENDPOINT_URL']
    raise TapyrusApi::UrlNotFound, "接続先URLが正しくありません" if URI::DEFAULT_PARSER.make_regexp.match(@url).blank?
    @connection ||= Faraday.new(@url) do |builder|
      builder.response :raise_error
      builder.response :json, parser_options: { symbolize_names: true }, content_type: 'application/json'
      builder.ssl[:client_cert] = client_cert
      builder.ssl[:client_key] = client_key
    end
  end

  private

  def client_cert
    OpenSSL::PKCS12.new(load_client_cert_p12, ENV['PKCS_12_PASS']).certificate
  rescue Errno::ENOENT => e
    Rails.logger.error(e)
    raise TapyrusApi::FileNotFound, 'クライアント証明書がありません'
  end

  def client_key
    OpenSSL::PKCS12.new(load_client_cert_p12, ENV['PKCS_12_PASS']).key
  rescue Errno::ENOENT => e
    Rails.logger.error(e)
    raise TapyrusApi::FileNotFound, 'クライアント証明書がありません'
  end

  def load_client_cert_p12
    File.read(Rails.root.join("tapyrus_api_client_cert.p12"))
  end
end
