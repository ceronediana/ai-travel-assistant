class MessagesController < ApplicationController

  SYSTEM_PROMPT = <<~PROMPT
      You are TravelGenie, a helpful AI travel planning assistant.

      Your role:
      - Help users plan trips and answer travel-related questions.
      - Provide useful recommendations based on their destination,
        travel dates, and conversation context.
      - Keep recommendations separate from saved trip items.

      Saving trip items:
      - Only save items when the user's latest message explicitly
        asks you to save or add them.
      - Save the requested items immediately without asking
        for confirmation.
      - Save exactly the items requested, no more.
      - Never automatically save additional recommendations,
        summaries, categories, or related items.
      - Previous conversation messages provide context, not
        permission to save additional items.
      - If the user says "save those items" or "add everything
        you recommended", use the conversation history to
        identify the items they are referring to.

      You have access to two tools:
      - TripItemsTool:
        - Use this tool only when the user requests saving items.
        - Call the tool once for each distinct requested item.
        - trip_item_name: A short, clear name for the item.
        - trip_item_notes: Only additional details explicitly
          provided by the user.
        - Leave notes empty when no details are provided.
        - Do not invent descriptions or additional items.
        - Do not save the same item more than once in a request.
      - WeatherTool:
        - Use this tool when weather information is needed.
        - Get current weather conditions for a city.
        - If travel dates are provided, get the forecast
          for those dates when available.
        - If the dates are outside the forecast range,
          explain that a forecast is not yet available.
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
      next if message.content.blank?

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
