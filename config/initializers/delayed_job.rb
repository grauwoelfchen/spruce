Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 30
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 3.minutes
Delayed::Worker.read_ahead = 5
Delayed::Worker.default_queue_name = "default"
Delayed::Worker.delay_jobs = !Rails.env.test?
Delayed::Worker.raise_signal_exceptions = :term

log_file = File.join(Rails.root, "log", "delayed_job.log")
Delayed::Worker.logger = Logger.new(log_file)
