# redisの便利メソッド
require "redis"
require "connection_pool"
require "oj"

$redis = ConnectionPool::Wrapper.new(size: 32, timeout: 3) { Redis.new(host: ENV["REDIS_HOST"]) }

::Oj.default_options = { mode: :compat }

module RedisMethods
  # redisにあればredisから取得し、キャッシュになければブロック内の処理で取得しredisに保存するメソッド（Rails.cache.fetchと同様のメソッド）
  #
  # @param cache_key [String]
  # @param enabled [Boolean] キャッシュを有効にするかどうか
  # @param is_object [Boolean] String以外を保存するかどうか
  #
  # @yield キャッシュがなかった場合に実データを取得しにいくための処理
  # @yieldreturn [Object] redisに保存されるデータ
  #
  # @return [Object] redisに保存されるデータ
  def with_redis(cache_key, enabled: true, is_object: false)
    unless enabled
      return yield
    end

    cached_response = $redis.get(cache_key)
    if cached_response
      if is_object
        # return Marshal.load(cached_response)
        return Oj.load(cached_response)
      else
        return cached_response
      end
    end

    actual = yield

    if actual
      if is_object
        # data = Marshal.dump(actual)
        data = Oj.dump(actual)

        $redis.set(cache_key, data)
      else
        $redis.set(cache_key, actual)
      end
    end

    actual
  end

  # @param user_id [Integer]
  # @param session_id [Integer]
  # @param created_at [Integer]
  # @param updated_at [Integer]
  # @param expired_at [Integer]
  # @param deleted_at [Integer]
  def set_user_session(user_id:, session_id:, created_at:, updated_at:, expired_at:, deleted_at: 0)
    $redis.set("user_session:#{user_id}:#{session_id}", {
      user_id: user_id,
      created_at: created_at,
      updated_at: updated_at,
      expired_at: expired_at,
      deleted_at: deleted_at,
    }.to_json)
  end

  # @param user_id [Integer]
  # @param session_id [Integer]
  # @param deleted_at [Integer]
  def update_user_sessions_deleted_at(user_id:, session_id: nil, deleted_at:)
    if session_id
      # 単一セッションだけ更新
      key = "user_session:#{user_id}:#{session_id}"
      user_session = Oj.load($redis.get(key))
      user_session.transform_keys!(&:to_sym)

      user_session[:deleted_at] = deleted_at
      $redis.set(key, user_session.to_json)
    end

    # 複数セッションまとめて更新
    keys = $redis.keys("user_session:#{user_id}:*")
    keys.each do |key|
      user_session = Oj.load($redis.get(key))
      user_session.transform_keys!(&:to_sym)

      user_session[:deleted_at] = deleted_at
      $redis.set(key, user_session.to_json)
    end
  end

  def get_user_session(user_id:, session_id:, only_active: false)
    key = "user_session:#{user_id}:#{session_id}"
    user_session = Oj.load($redis.get(key))
    user_session.transform_keys!(&:to_sym)

    if only_active && user_session[:deleted_at] > 0
      return nil
    end

    user_session
  end

  def initialize_redis
    $redis.flushall
  end
end
