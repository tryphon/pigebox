require 'pige'
require 'rsox-command'

Pige::Record::Index.record_directory = "/srv/pige/records"

Steto.config do
  def pige_index
    @pige_index ||= Pige::Record::Index.new
  end

  process "alsa-backup"

  nagios :pige_current_file_modified, "check_file_age", :w => "30", :c => "60", :f => pige_index.current_record

  nagios :pige_free_space, "check_disk", :warning => 4.gigabytes.in_megabytes.to_s, :critical => 1.gigabyte.in_megabytes.to_s, :ereg_path => "/srv/pige"

  check :pige_last_pige_not_silent do
    begin
      Sox::Stats.new(pige_index.last_record, :use_cache => true).silent?
    rescue => e
      Steto.logger.debug "Can't read last pige file: #{Pige.last_file}: #{e}"
      nil
    end
  end
end
