class MessagesController < ApplicationController

  SYSTEM_PROMPT = <<~PROMPT
      # ...
      You have access to two tools:
      - TripItemsTool: Create a Trip Item with a name based on what the user tells you to add, and notes if the user gives you specifics about the Trip Item. Do not create multiple trip items.
      - WeatherTool:
        - Get current weather conditions for a city
        - If the user provides travel start and end dates, get the weather forecast for those dates
        - If the requested dates are outside the available forecast range, explain that a forecast is not yet available
      # ...
    PROMPT

  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history

      @ruby_llm_chat.with_tool(TripItemsTool.new(trip_id:@chat.trip.id))
      @ruby_llm_chat.with_tool(WeatherTool.new)

      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      @assistant_message = Message.create(role: "assistant", content: response.content, chat: @chat)
      @chat.generate_title_from_first_message

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  def build_conversation_history
    @chat.messages.where.not(id: @message.id).each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end


  private

  def trip_context
    "The user is planning a trip to #{@chat.trip.destination} from #{@chat.trip.start_date} to #{@chat.trip.end_date}. Use this destination and these dates as context when answering travel questions unless the user specifies otherwise."
  end

  def instructions
    [SYSTEM_PROMPT, trip_context].compact.join("\n\n")
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
