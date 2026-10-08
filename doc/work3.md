# Work3 タイムスタンプを記録する

Work1・Work2が終わった人向けの追加ワークです。画面に入力した短いメッセージのハッシュ（データの「指紋」）をTapyrusに記録し、結果を読み戻します。目安は15〜25分です。

画面は用意されています。今回実装するのは、画面からTapyrus APIを呼ぶ3つのメソッドです。

## 1. 実装するファイル

`lib/utils/tapyrus_api.rb` の `TapyrusApi` クラスを編集します。Work1で使った `TapyrusTaskApi` とは別の、Webアプリ用のクラスです。Work1・Work2で書いたメソッドはそのままにしてください。

次の3つの未実装メソッドを実装します。

```ruby
def get_timestamps
  res = instance.connection.get('/api/v2/timestamps') do |req|
    req.headers['Authorization'] = "Bearer #{instance.access_token}"
  end

  res.body
end

def get_timestamp(id)
  res = instance.connection.get("/api/v2/timestamps/#{id}") do |req|
    req.headers['Authorization'] = "Bearer #{instance.access_token}"
  end

  res.body
end

def post_timestamp(content:, digest:, prefix:, type:)
  res = instance.connection.post('/api/v2/timestamps') do |req|
    req.headers['Authorization'] = "Bearer #{instance.access_token}"
    req.headers['Content-Type'] = 'application/json'
    req.body = JSON.generate({
      content: content,
      digest: digest,
      prefix: prefix,
      type: type
    })
  end

  res.body
end
```

`GET` は取得、`POST` は新規作成です。画面で入力した文字列は、Rails側でAPIが受け付ける16進数に変換されます。`digest: sha256` を指定しているため、APIはその内容のSHA-256ハッシュを記録します。

## 2. ブラウザで試す

Codespacesの「ポート」にある3000番の**転送されたアドレス**をクリックし、URLの末尾に `/timestamps/new` を付けて開きます。

1. `Content` に `B3-2026` を入力する。`Prefix` は空欄にする。
2. 「BCに記録」を押す。
3. 詳細画面の `id`・`txid`・`content_hash`・`status` を見る。
4. 上部メニューの「Timestamp」から一覧を開き、同じ記録を探す。

作成直後の `status` が `unconfirmed` でも異常ではありません。時間をおいて詳細を再読み込みし、`confirmed` になるか確認してください。`txid` が返ることと、ブロックに記録されることは別です。

## 3. ハッシュを比べる

Codespacesの `bash` ターミナルで次を実行し、画面の `content_hash` と比較します。

```bash
ruby -rdigest -e 'puts Digest::SHA256.hexdigest("B3-2026")'
```

計算結果は `569d9be70d53ee5c026895ea0bfe6c386b2b7c430dcbff506cb9458c4033e8fe` です。次に1文字だけ変えて計算し、ハッシュがどう変わるか見てください。

## 考えてみよう

- `id` はAPI内の記録、`txid` はTapyrusのトランザクションを指します。なぜ2つ必要でしょうか。
- ハッシュが一致すると、同じ内容であることを確認できます。内容が真実かどうかまで分かるでしょうか。

参考：[Tapyrus APIのtimestamp v2仕様](https://doc.api.tapyrus.chaintope.com/#tag/timestamp-v2)
