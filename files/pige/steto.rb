require 'pige'
require 'rsox-command'

Pige::Record::Index.record_directory = "/srv/pige/records"

Steto.config do
  def pige_index
    @pige_index ||= Pige::Record::Index.new
  end

  process "go-broadcast"

  def current_record_filename
    # FIXME doesn't see restart file like '09h01m38.wav'
    "#{pige_index.directory}/#{pige_index.basename_at(Time.now)}.wav"
  end

  nagios :pige_current_file_modified, "check_file_age", :w => "0", :c => "60", :f => current_record_filename

  nagios :pige_free_space, "check_disk", :warning => 4.gigabytes.in_megabytes.to_s, :critical => 1.gigabyte.in_megabytes.to_s, :ereg_path => "/srv/pige"

  check :pige_last_pige_not_silent do
    if pige_index.last_record
      begin
        Sox::Stats.new(pige_index.last_record.filename, :use_cache => true).silent?
      rescue => e
        Steto.logger.debug "Can't read last pige file: #{e}"
        nil
      end
    else
      false
    end
  end
end
