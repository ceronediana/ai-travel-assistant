class Chat < ApplicationRecord
  belongs_to :trip
  belongs_to :user
  has_many :messages, dependent: :destroy

  DEFAULT_TITLE = "Untitled"
  TITLE_PROMPT = <<~PROMPT
  You are a chat title generator, not a conversational assistant.

  Your only task is to create a short, descriptive title
  summarizing the user's message.

  Rules:
  - Use 3 to 6 words.
  - Return ONLY the title.
  - Never answer the user's question.
  - Never ask follow-up questions.
  - Do not include quotation marks or explanations.
PROMPT

  def generate_title_from_first_message
    return unless title == DEFAULT_TITLE

    first_user_message = messages.where(role: "user").order(:created_at).first
    return if first_user_message.nil?

    response = RubyLLM.chat.with_instructions(TITLE_PROMPT).ask(
      "Trip destination: #{trip.destination}\nUser message: #{first_user_message.content}"
    )

    update(title: response.content)
  end
end
