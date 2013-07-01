#! /usr/bin/env ruby

class PurgeableFileList
  KNOWN_SKIPPABLES = ['.', '..']
  attr_reader :files
  def initialize path, age
    @path = path
    @age_cutoff = Time.zone.now - age.days
    generate_file_list
  end

  private
  def generate_file_list
    get_all_files_in_purge_directory
    remove_known_skippable_files
    remove_files_too_young_to_purge
  end

  def get_all_files_in_purge_directory
    @files = Dir.entries(@path)
    @files.map!{|file| File.join(@path, file)}
  end

  def remove_known_skippable_files
    @files = @files - KNOWN_SKIPPABLES
  end
  def remove_files_too_young_to_purge
    @files.reject!{|file| File.mtime(file) > @age_cutoff }
  end
end

class PurgeFiles
  DEFAULT_DAYS_TO_KEEP = 30

  opts_banner = "Usage: ./purge_report_files.rb [options]"
  opts_description "By default, this will purge UI Report Files, though it can be\nturned on other things with the proper options."

  opts_required :path_to_purge
  opts_accessor :keep_n_days, :path_to_purge

  opts_on("-k", "--keep-n-days DAYS", Integer, "Keep N days of files.", "\tDefault: --keep-n-days #{DEFAULT_DAYS_TO_KEEP}") do |days|
    options.keep_n_days = days
  end

  opts_on("-p", "--path-to-purge PATH", "Purge files from PATH", "Required") do |path|
    options.path_to_purge = path
  end


  def post_initialize
    options.keep_n_days ||= DEFAULT_DAYS_TO_KEEP
  end

  run do
    message "Checking for directory #{options.patth_to_purge}."
    if directory_found?
      message "Directory #{options.path_to_purge} found."
      message "Getting list of files."
      message "#{files.size} files found."
      remove_files
      message "Fin!"
    end
  end

  private

  def directory_found?
    found = File.directory? path_to_purge
    error_message "Directory '#{options.path_to_purge}'not found." unless found
    found
  end

  def files
    @files ||= PurgeableFileList.new(path_to_purge, keep_n_days).files
  end

  def remove_files
    files.each do |file|
      message "Deleting '#{file}'."
      File.delete(file) unless options.dry_run
    end
  end
end

exit PurgeFiles.new(ARGV).run
