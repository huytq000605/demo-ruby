module R
  class H

    attr_accessor :file, :data

    def initialize
      @file = "/tmp/report-#{Time.now}"
    end

    def call
      query
      process
      export
    end

    def ats
      <<-SQL
      SELECT o.legacy_id as organisation_id,#{' '}
      COUNT(*) AS total,#{' '}
      COUNT(*) FILTER (WHERE j.created_at >= '2021-10-01 00:00:00' AND j.created_at < '2021-11-01 00:00:00') AS total_october,
      COUNT(*) FILTER (WHERE j.created_at >= '2021-11-01 00:00:00' AND j.created_at < '2021-12-01 00:00:00') AS total_november,
      COUNT(*) FILTER (WHERE j.created_at >= '2021-12-01 00:00:00' AND j.created_at < '2022-01-01 00:00:00') AS total_december
      FROM jobs j JOIN organisations o ON j.organisation_id = o.id
      WHERE j.created_at >= '2021-10-01 00:00:00' AND j.created_at < '2022-01-01 00:00:00'#{' '}
      GROUP BY o.legacy_id
      ORDER BY o.legacy_id
      SQL
    end

    def main_app
      <<-SQL
      SELECT m.organisation_id, i.title as industry, o.country, o.name, p.name as subscription_plan,
      COUNT(*) AS total,#{' '}
      COUNT(*) FILTER (WHERE m.created_at >= '2021-10-01 00:00:00' AND m.created_at < '2021-11-01 00:00:00') AS total_october,
      COUNT(*) FILTER (WHERE m.created_at >= '2021-11-01 00:00:00' AND m.created_at < '2021-12-01 00:00:00') AS total_november,
      COUNT(*) FILTER (WHERE m.created_at >= '2021-12-01 00:00:00' AND m.created_at < '2022-01-01 00:00:00') AS total_december
      FROM members m 
      JOIN organisations o on m.organisation_id = o.id 
      JOIN industry_categories i on o.industry_category_id = i.id 
      LEFT JOIN subscriptions s on s.organisation_id = o.id 
      LEFT JOIN subscription_plans p on s.subscription_plan_id = p.id 
      WHERE m.created_at >= '2021-10-01 00:00:00' AND m.created_at < '2022-01-01 00:00:00' 
      GROUP BY m.organisation_id, i.title, o.country, o.name, p.name 
      ORDER BY m.organisation_id
      SQL
    end

    def query
      sql = main_app
      @data = ActiveRecord::Base.connection.execute(sql)
    end

    def process
      orgs = ::Organisation.includes(:subscription_plans).where(id: data.map {|row| row["organisation_id"]})
      orgs_hash = {}
      orgs.each do |org|
        orgs_hash[org.id] = org
      end

      puts "Count Orgs: #{orgs.length}"

      File.open(file, 'w') do |f|
        data.to_a.each do |row|
          row["subscription_plan"] = orgs_hash[row["organisation_id"]].current_subscription_plan['name']
          f << "#{row},\n"
        end
      end
    end

    def upload_csv_mainapp
      api_key = ENV['FILEPICKER_API_KEY']
      secret_key = ENV['FILEPICKER_SECRET_KEY']
      options = %w[pick store read].freeze

      security = FilestackSecurity.new(secret_key, options: { call: options })
      client = FilestackClient.new(api_key, security: security)

      uploaded_file = client.upload(filepath: file)
      url = uploaded_file&.url
    end

    def upload_csv_ats
      api_key = ENV['FILESTACK_API_KEY']
      secret_key = ENV['FILESTACK_SECRET_KEY']
      options = %w[pick store read].freeze

      security = FilestackSecurity.new(secret_key, options: { call: options })
      client = FilestackClient.new(api_key, security: security)

      uploadted_file = client.upload(filepath: file)
      url = uploaded_file&.url
    end
  end
end
