class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      instructions = "The user is planning a trip to #{@chat.trip.destination}. Use this destination as context when answering travel questions unless the user specifies otherwise."
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

  def message_params
    params.require(:message).permit(:content)
  end
end
