class OnlineCounterChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'online_counter'
  end

  def broadcast_count(data)
    online_count = ActionCable.server.connections.size
    ActionCable.server.broadcast 'online_counter', { 'count' => online_count }
  end
end
