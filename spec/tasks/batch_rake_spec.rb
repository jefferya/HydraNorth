require 'spec_helper'

describe "Batch Ingest rake tasks", type: :task do
  before(:all) do
    load_rake_environment('tasks/batch')
  end

  describe "ingest_csv: batch ingest from a csv file" do
    before(:each) do
      cleanup_jetty
      @community = Collection.new(title: 'test community') do |c|
        c.apply_depositor_metadata('dittest@ualberta.ca')
        c.is_community = true
        c.is_official = true
        c.save
      end
      @collection = Collection.new(title: 'test collection') do |c|
        c.apply_depositor_metadata('dittest@ualberta.ca')
        c.is_official = true
        c.save
      end

      run_rake_task('batch:ingest_csv', 'spec/fixtures/batch/csv/batchData.csv', 'spec/fixtures/batch/csv/batchFiles','investigation-test001', 'ingest')
      result = ActiveFedora::SolrService.instance.conn.get "select", params: {q:["title:test object for batch ingest csv"]}
      doc = result["response"]["docs"].first
      id = doc["id"]
      @file = GenericFile.find(id)
    end

    after(:each) do
      cleanup_jetty
    end

    it "item should be ingested" do
      expect(@file).not_to be_nil
      expect(@file.license).to eq "Attribution 4.0 International"
      expect(@file.resource_type).to eq "Journal Article (Published)"
      expect(@file.institutional_visibility?).to be false
      expect(@file.hasCollectionId).to eq([@collection.id])
      expect(@file.belongsToCommunity).to eq([@community.id])
    end
  end
end
