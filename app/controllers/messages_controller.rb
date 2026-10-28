class MessagesController < ApplicationController
    def create
    @chat = Chat.new(chat_params)
    @chat.response = RubyLLM.chat.ask("#{@chat.message}").content
    if @chat.save
      redirect_to chat_path(@chat), notice: "Chat was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
end
