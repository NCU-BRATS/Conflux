require 'rails_helper'

RSpec.describe ChannelOperation::Update do

  include_context 'channel with project and members'

  subject { ChannelOperation::Update.new(@members[0], @project, @channel) }

  describe '#process' do

    context 'when given valid params' do

      it 'changes the name' do
        subject.process( new_param( { channel: { name: 'name_changed' } } ) )
        expect(@channel.name).to eq 'name_changed'
      end

      it 'changes the description' do
        subject.process( new_param( { channel: { description: 'description_changed' } } ) )
        expect(@channel.description).to eq 'description_changed'
      end

      it 'changes the announcement' do
        subject.process( new_param( { channel: { announcement: 'announcement_changed' } } ) )
        expect(@channel.announcement).to eq 'announcement_changed'
      end

    end

    context 'when given incorrect params' do
      it 'raise ActionController::ParameterMissing' do
        expect{subject.process(new_param)}.to raise_error ActionController::ParameterMissing
      end
    end

  end
end
