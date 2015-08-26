require 'rails_helper'

RSpec.describe ChannelOperation::Create do

  include_context 'project with members'

  describe '#process' do

    context 'when given valid params' do

      before(:context) do
        @params = new_param ({
          channel: {
            name: 'testname',
            description: 'testdescription',
            announcement: 'testannouncement'
          }
        })
        @operation = ChannelOperation::Create.new( @members[0], @project )
        @operation.process( @params )
      end

      it 'creates a record in database' do
        expect( @operation.model.persisted? ).to be true
      end

      it 'creates a channel with the given project, user and other attributes' do
        conditions = [
          @operation.model.project == @project,
          @operation.model.name         == 'testname',
          @operation.model.description  == 'testdescription',
          @operation.model.announcement == 'testannouncement',
          @operation.model.order == @project.channels.maximum('order')
        ]
        expect( conditions ).to all( be true )
      end

      it 'creates a record in database' do
        expect( @operation.model.persisted? ).to be true
      end

      it 'adds creator to member' do
        expect( @operation.model.members.include? @members[0] ).to be true
      end

      it 'fires corresponding event' do
        expect{ ChannelOperation::Create.new( @members[1], @project ).process( @params ) }.to broadcast( :on_channel_created )
      end

    end

    context 'when given incorrect params' do
      it 'raise ActionController::ParameterMissing' do
        expect{ ChannelOperation::Create.new( @members[1], @project ).process( new_param ) }.to raise_error ActionController::ParameterMissing
      end
    end

  end

end
