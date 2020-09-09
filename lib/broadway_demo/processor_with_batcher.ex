defmodule BroadwayDemo.ProcessorWithBatcher do
  use Broadway

  import BroadwayDemo.MyInteger

  alias Broadway.Message
  alias BroadwayDemo.Producer

  def start_link(_opts) do
    Broadway.start_link(BroadwayDemo.ProcessorWithBatcher,
      name: BroadwayDemo,
      producer: [
        module: {Producer, 1},
        transformer: {__MODULE__, :transform, []},
        concurrency: 1
      ],
      processors: [
        default: [concurrency: 2]
      ],
      batchers: [
        odd_batcher: [batch_size: 10],
        even_batcher: [batch_size: 10]
      ]
    )
  end

  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  @impl true
  def handle_message(_, %Message{data: data} = message, _) when is_odd(data) do
    message
    |> Message.put_batcher(:odd_batcher)
  end

  def handle_message(_, %Message{data: data} = message, _) when is_even(data) do
    message
    |> Message.put_batcher(:even_batcher)
  end

  @impl true
  def handle_batch(:odd_batcher, messages, _batch_info, _context) do
    messages
  end

  def handle_batch(:even_batcher, messages, _batch_info, _context) do
    IO.inspect("even batcher #{length(messages)}")
    messages
  end

  def ack(:ack_id, _successful, _failed) do
    :ok
  end
end
