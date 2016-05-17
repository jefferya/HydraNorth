require 'spec_helper'

RSpec.describe RecentController, type: :controller do
  routes { Rails.application.class.routes }

  describe "GET #index" do

    before :each do
      @gf1 = GenericFile.new(title: ['Test Document PDF'], filename: ['test.pdf'], subject: ['rocks'], read_groups: ['public'])
      @gf1.apply_depositor_metadata('mjg36')
      old_to_solr = @gf1.method(:to_solr)
      allow(@gf1).to receive(:to_solr) do
        old_to_solr.call.merge(
          Solrizer.solr_name('system_create', :stored_sortable, type: :date) => Time.parse("2016-04-29T16:25:21Z").iso8601
        )
      end
      @gf1.save
      @gf2 = GenericFile.new(title: ['Test Private Document'], filename: ['test2.doc'], subject: ['clouds'], contributor: ['Contrib1'], read_groups: ['private'])
      @gf2.apply_depositor_metadata('mjg36')
      old_to_solr = @gf2.method(:to_solr)
      allow(@gf2).to receive(:to_solr) do
        old_to_solr.call.merge(
          Solrizer.solr_name('system_create', :stored_sortable, type: :date) => Time.parse("2016-05-1    0T22:42:30Z").iso8601
        )
      end
      @gf2.save

      Timecop.freeze(Time.parse("2016-04-29T16:25:21Z"))
    end

    after :each do
      cleanup_jetty
      Timecop.return
    end

    it "does not include other user's private documents in recent documents" do
      get :index
      expect(response).to be_success
      titles = assigns(:recent_documents).map { |d| d['title_tesim'][0] }
      expect(titles).to_not include('Test Private Document')
    end

    it "includes only GenericFile objects in recent documents" do
      get :index
      assigns(:recent_documents).each do |doc|
        expect(doc[Solrizer.solr_name("has_model", :symbol)]).to eql ["GenericFile"]
      end
    end

    it 'includes date buckets for crawling' do
      get :index
      expect(assigns(:date_buckets)).to include "2016"=>[["2016-04-01T00:00:00Z", 1]]
    end

    context "with a document not created this second" do
      before do
        gw3 = GenericFile.new(title: ['Test 3 Document'], read_groups: ['public'])
        gw3.apply_depositor_metadata('mjg36')
        # stubbing to_solr so we know we have something that didn't create in the current second
        old_to_solr = gw3.method(:to_solr)
        allow(gw3).to receive(:to_solr) do
          old_to_solr.call.merge(
            Solrizer.solr_name('system_create', :stored_sortable, type: :date) => (Time.now - 1.day).utc.iso8601
          )
        end
        gw3.save
      end

      it "sets recent documents in the right order" do
        get :index
        expect(response).to be_success
        expect(assigns(:recent_documents).length).to be <= 4
        create_times = assigns(:recent_documents).map { |d| d['system_create_dtsi'] }
        expect(create_times).to eq create_times.sort.reverse
      end 
    end

    context "with a document not created in the last two weeks" do
      before do
        gf4 = GenericFile.new(title: ['Test 4 Document'], read_groups: ['public'])
        gf4.apply_depositor_metadata('mjg36')
        #stubbing to_solr so we know we have something significantly older
        old_to_solr = gf4.method(:to_solr)
        allow(gf4).to receive(:to_solr) do
          old_to_solr.call.merge(
            Solrizer.solr_name('system_create', :stored_sortable, type: :date) => (Time.now - 15.day).utc.iso8601
          )
        end
        gf4.save

        gf5 = GenericFile.new(title: ['Test 5 Document'], read_groups: ['public'])
        gf5.apply_depositor_metadata('mjg36')
        #stubbing to_solr so we know we have something significantly older
        old_to_solr = gf5.method(:to_solr)
        allow(gf5).to receive(:to_solr) do
          old_to_solr.call.merge(
            Solrizer.solr_name('system_create', :stored_sortable, type: :date) => (Time.now - 32.day).utc.iso8601
          )
        end
        gf5.save
      end
      
      it "doesn't include older documents" do
        get :index
        expect(response).to be_success
        expect(assigns(:recent_documents).length).to eq 0 
        create_times = assigns(:recent_documents).map { |d| d['system_create_dtsi'] }
        expect(create_times).to_not include((Time.now - 15.days).utc.iso8601)
      end
      it "includes all documents in date bucket" do
        get :index, {:year => Time.now.year}
        expect(response).to be_success
        expect(assigns(:recent_documents).length).to eq 3 
      end
      it "includes all documents in month date bucket" do
        get :index, {:year => (Time.now - 1.month).year, :month => (Time.now - 1.month).month}
        expect(response).to be_success
        expect(assigns(:recent_documents).length).to eq 1 
      end
      it "excludes all documents not in date bucket" do
        get :index, {:year => 1.year.ago.year}
        expect(response).to be_success
        expect(assigns(:recent_documents).length).to eq 0
      end
      it 'includes date buckets for crawling' do
        get :index
        expect(assigns(:date_buckets)).to include "2016" => [["2016-03-01T00:00:00Z", 1], ["2016-04-01T00:00:00Z", 2]]
      end
    end

    context "with a document not created in the last year" do
      before do 
        gf6 = GenericFile.new(title: ['Test 6 Document'], read_groups: ['public'])
        gf6.apply_depositor_metadata('mjg36')
        #stubbing to_solr so we know we have something significantly older
        old_to_solr = gf6.method(:to_solr)
        allow(gf6).to receive(:to_solr) do
          old_to_solr.call.merge(
            Solrizer.solr_name('system_create', :stored_sortable, type: :date) => (Time.now - 1.year).utc.iso8601
          )
        end
        gf6.save
      end

      it 'includes date buckets for crawling' do
        get :index
        expect(assigns(:date_buckets)).to include "2016"=>[["2016-04-01T00:00:00Z", 1]]
        expect(assigns(:date_buckets)).to include "2015" => [["2015-04-01T00:00:00Z", 1]]
      end
    end
  end

end
