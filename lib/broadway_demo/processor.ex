defmodule BroadwayDemo.Processor do
  use Broadway

  import BroadwayDemo.MyInteger

  alias Broadway.Message
  alias BroadwayDemo.Producer

  def start_link(_opts) do
    Broadway.start_link(BroadwayDemo.Processor,
      name: BroadwayDemo,
      producer: [
        module: {Producer, 1},
        transformer: {__MODULE__, :transform, []},
        concurrency: 1
      ],
      processors: [
        default: [concurrency: 2]
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
    IO.inspect(data)
    message
  end

  def handle_message(_, %Message{data: data} = message, _) when is_even(data) do
    IO.inspect("even!")
    message
  end

  def ack(:ack_id, _successful, _failed) do
    :ok
  end
end
