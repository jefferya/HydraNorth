# spec/models/user.rb
require 'spec_helper'

describe User, type: :model do

  describe "#name" do
    subject { FactoryGirl.build_stubbed(:new_user)}
    it "should not tamper with the user's display name" do
      subject.display_name = "Raymond luxury-Yacht"
      expect(subject.name).to eq "Raymond luxury-Yacht"
    end
  end

  before { ActionMailer::Base.deliveries = [] }

  context "standard new user" do
    subject { FactoryGirl.create(:new_user) }
    it { should be_valid}

    it 'should reject invalid passwords' do
      expect(subject.valid_password?('asdfkaslfjasldkjf')).to be(false)
    end

    it 'should accept valid passwords' do
      expect(subject.valid_password?('123456789')).to be(true)
    end
  end


  context "legacy user" do
    subject { FactoryGirl.create(:legacy_user) }

    it 'should be a valid user' do
      should be_valid
      expect(subject.legacy_password).not_to be_nil
    end

    describe "#valid_password?" do

      it 'should reject invalid legacy passwords' do
        subject.valid_password?('12345678')
      end

      it "converts legacy password" do
        old_password = subject.legacy_password
        old_encrypted_password = subject.encrypted_password
        expect(subject.valid_password?('123456789')).to be_truthy
        expect(subject.reload.encrypted_password).not_to eq(old_encrypted_password)
        expect(subject.legacy_password).to be_nil
      end
    end
  end

  it "need to confirm a new user" do
    user = User.create({
      :email => "dit.test@ualberta.ca",
      :password => "devisetest",
      :password_confirmation => "devisetest",
    })

    expect(user.confirmed?).to be_falsey

    user.confirm

    expect(user.confirmed?).to be_truthy

  end

  context "ccid user" do
    subject { FactoryGirl.create(:new_user) }
    it "should need to confirm adding a ccid" do
      subject.ccid = 'myself@testshib.org'
      expect { subject.confirm_ccid! }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(subject.confirmed?).to be_falsey
      subject.confirm
      expect(subject.ccid).to eq 'myself@testshib.org'
      expect(subject.confirmed?).to be_truthy
    end

  end

  let(:user) { FactoryGirl.create(:user) }
  it "can lock and unlock user access" do
    user.lock_access!
    expect(user.access_locked?).to be_truthy
    user.unlock_access!
    expect(user.access_locked?).to be_falsey
  end
end
