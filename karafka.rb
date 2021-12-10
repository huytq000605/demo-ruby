require ::File.expand_path('../config/environment', __FILE__)
require ::File.expand_path('config/environment', __dir__)

KAFKA_BROKERS = 'kafka://127.0.0.1:9092'

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = KAFKA_BROKERS.split(",")
    # config.kafka = { 'bootstrap.servers' => '127.0.0.1:9092' }
    config.client_id = 'example_app'
  end


  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Rails.application.eager_load!
  Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  consumer_groups.draw do
    topic 'mytopic' do 
      consumer Mytopic
      start_from_beginning false
      max_bytes_per_partition 100
    end 

    KafkaHandleEvent.topics.each do |topic_name|
      topic topic_name do
        consumer ::KafkaHandleEvents
        start_from_beginning false
      end
    end

  end
end