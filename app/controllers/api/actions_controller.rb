class Api::ActionsController < Api::ApiController

  def create
    payload = JSON.parse(params[:payload])
    user = User.find_by_slack_id(payload['user']['id'])

    if user.nil?
      respond_with_error
      return
    end

    callback_id = payload['callback_id']
    action_name = payload['actions'].first['name']
    action_value = payload['actions'].first['value']

    case callback_id
    when 'tasks'
      case action_name
      when 'complete'
        task = Task.find_by_id(action_value)

        if task.present?
          user.tasks << task

          public_message = "*The fantastic @#{user.name} just completed his/her " +
            "#{user.tasks.count.ordinalize} to-do:* 🎉\n#{task.description}"
          announce_task_completion public_message

          confirmation_message = "✅ *Nice job! You finished this to-do " +
            "item:*\n#{task.description}"

          render json: base_response(confirmation_message), status: :ok
        else
          respond_with_error
        end
      end
    end
  end

  private

  def base_response(text)
    { response_type: 'ephemeral', replace_original: true,
      text: text
    }
  end

  def respond_with_error
    error_response = base_response("Sorry, that didn't work. Please try again.")
    render json: error_response, status: :ok
  end

  def announce_task_completion(msg)
    HTTParty.post('https://slack.com/api/chat.postMessage',
                  body: { token: SLACK_AUTH_TOKEN,
                          channel: SLACK_GENERAL_CHANNEL_ID,
                          text: msg }).parsed_response
  end

end