json.partial! partial: 'projects/comments/comment', collection: @issue.comments.includes(:user).asc, as: :comment