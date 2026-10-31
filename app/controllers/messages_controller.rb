class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"
    #response = RubyLLM.chat.ask("#{@chat.message}").content
    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      #response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)
      response = "Message created!!!"
      #@assistant_message = Message.create(role: "assistant", content: response.content, chat: @chat)
      @assistant_message = Message.create(role: "assistant", content: response, chat: @chat)
      #@chat.generate_title_from_first_message

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end


  private

  def message_params
    params.require(:message).permit(:content)
  end
end
