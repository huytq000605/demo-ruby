file = File.join(Rails.root, 'credentials.json')
credentials = JSON.parse(File.read(file))
ENV['AZURE_APP_ID'] = credentials['AZURE_APP_ID']
ENV['AZURE_APP_SECRET'] = credentials['AZURE_APP_SECRET']
ENV['AZURE_SCOPES'] = credentials['AZURE_SCOPES']
