require 'spec_helper'
require 'rake'

describe "sitemap:generate" do
  before :all do
    Rake.application.rake_require 'tasks/sitemap'
    Rake::Task.define_task(:environment)
    ENV["LOCATION"] = "#{Rails.root}/tmp"
    Timecop.freeze
  end

  let(:user) { FactoryGirl.find_or_create(:jill) }
  let!(:private_file) do
    GenericFile.new.tap do |f|
      f.title = ['private']
      f.read_groups = ['private']
      f.apply_depositor_metadata(user.user_key)
      f.save!
    end
  end
  let!(:broken_file) do
    GenericFile.new.tap do |f|
      f.title = ['broken']
      f.read_groups = ['public']
      f.apply_depositor_metadata(user.user_key)
      f.save!
    end
  end
  let!(:missing_hash_file) do
    GenericFile.new.tap do |f|
      f.title = ['missing hash']
      f.read_groups = ['public']
      f.apply_depositor_metadata(user.user_key)
      f.save!
      allow(f.characterization).to receive(:digest).and_return nil
    end
  end
  let!(:public_file) do
    GenericFile.new.tap do |f|
      f.title = ['public']
      f.read_groups = ['public']
      f.apply_depositor_metadata(user.user_key)
      f.add_file(File.open(fixture_path + '/world.png'), path: 'content', original_name: 'world.png')
      f.save!
      f.characterize
    end
  end
  let!(:collection) do 
    Collection.new( title: "collection").tap do |c|
      c.apply_depositor_metadata(user.user_key)
      c.save!
    end
  end

  after do
    GenericFile.delete_all
    Collection.delete_all
    Timecop.return
  end

  it "should make digest return nil" do
    # using .find instance didn't allow the digest message to respond with nil
    # but the named instance will
    allow(GenericFile).to receive(:find).with(missing_hash_file.id).and_return missing_hash_file
    expect(GenericFile.find(missing_hash_file.id).characterization.digest).to be_nil
  end

  it "should create sitemap.xml which contains a file, collection and ommits the broken and private objects" do
    allow(GenericFile).to receive(:find).and_call_original
    allow(GenericFile).to receive(:find).with(broken_file.id) { raise ActiveFedora::ActiveFedoraError, "Model mismatch. Expected GenericFile. Got: ActiveFedora::Base>" }
    allow(GenericFile).to receive(:find).with(missing_hash_file.id).and_return missing_hash_file

    expect(Rails.logger).to receive(:error).with("id:#{broken_file.id} threw 'Model mismatch. Expected GenericFile. Got: ActiveFedora::Base>' and it was not included in the sitemap.xml")
    expect(Rails.logger).to receive(:error).with("id:#{missing_hash_file.id} threw 'undefined method `first' for nil:NilClass' and it was not included in the sitemap.xml")

    Rake::Task["sitemap:generate"].invoke

    expect(File).to exist("#{Rails.root}/tmp/sitemap.xml")
    file = File.read("#{Rails.root}/tmp/sitemap.xml")
    expect(file).to include Time.now.iso8601
    expect(file).to include public_file.id
    expect(file).to include collection.id
    expect(file).not_to include private_file.id
    expect(file).not_to include broken_file.id
    expect(file).not_to include missing_hash_file.id
  end
end
