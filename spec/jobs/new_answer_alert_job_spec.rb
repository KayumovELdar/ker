require 'rails_helper'

RSpec.describe NewAnswerAlertJob, type: :job do
  let(:service) { double('NewAnswerAlertService') }

  let(:question) { create(:question, user: create(:user)) }

  before do
    allow(NewAnswerAlertService).to receive(:new).and_return(service)
  end

  it 'calls NotificationService#notificate' do
    expect(service).to receive(:new_answer).with(question)
    NewAnswerAlertJob.perform_now(question)
  end
end
