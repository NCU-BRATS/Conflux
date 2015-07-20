class CreateJwtTokens < ActiveRecord::Migration
  def change
    create_table :jwt_tokens do |t|
      t.integer :exp
      t.integer :nbf
      t.string  :iss
      t.string  :aud
      t.integer :iat
      t.string  :sub

      t.timestamp :last_used_at

      t.timestamps
    end
  end
end
