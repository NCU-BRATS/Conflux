module PendingMemberOperation
  class Create < BaseForm

    property :invitee_emails, validates: {presence: true}, virtual: true

    def initialize(current_user, project)
      @current_user = current_user
      @project      = project
      super(PendingMember.new)
    end

    def process(params)
      if validate(pending_member_params(params))
        emails = invitee_emails.split( ',' )
        emails.each do |email|
          invitee_email = email.strip

          next if invitee_email.length == 0

          if user = User.where(email: invitee_email).where.not(confirmed_at: nil).first
            param = ActionController::Parameters.new( { project_participation: { user_id: user.id } } )
            ProjectParticipationOperation::Create.new( @current_user, @project ).process( param )
          elsif !PendingMember.exists?( invitee_email: invitee_email, project_id: @project.id )
            pending_member = PendingMember.new
            pending_member.project = @project
            pending_member.inviter = @current_user
            pending_member.invitee_email = invitee_email
            if pending_member.save
              BroadcastService.fire(:on_pending_member_created, pending_member, @current_user)
            end
          end
        end
      end
    end

  end
end
