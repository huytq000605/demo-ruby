class CreateJobTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :job_tokens do |t|
      t.uuid :job_id
      t.text :token

      t.timestamps
    end
  end
end
