# frozen_string_literal: true

RSpec.describe ActiveModel::IpAddressValidator do
  it "has a version number" do
    expect(ActiveModel::IpAddressValidator::VERSION).not_to be nil
  end

  describe "Validation" do
    class DummyModel
      include ActiveModel::Model

      attr_accessor :last_login_ip
    end

    after do
      DummyModel.clear_validators!
    end

    it "should be accept only v4/v6 ip address" do
      DummyModel.validates :last_login_ip, ip_address: true

      m = DummyModel.new

      m.last_login_ip = "192.0.2.1"
      expect(m).to be_valid

      m.last_login_ip = "2001:db8::dead:beaf"
      expect(m).to be_valid

      m.last_login_ip = "www.example.com"
      expect(m).to be_invalid
      expect(m.errors[:last_login_ip]).to eq ["is invalid"]
    end

    context "when version is not specified" do
      it "should be accept only v4/v6 ip address" do
        DummyModel.validates_ip_address_of :last_login_ip

        m = DummyModel.new

        m.last_login_ip = "192.0.2.1"
        expect(m).to be_valid

        m.last_login_ip = "2001:db8::dead:beaf"
        expect(m).to be_valid

        m.last_login_ip = "www.example.com"
        expect(m).to be_invalid
        expect(m.errors[:last_login_ip]).to eq ["is invalid"]
      end
    end

    context "when version v4 is specified" do
      it "should be accept only v4 ip address" do
        DummyModel.validates_ip_address_of :last_login_ip, version: :v4

        m = DummyModel.new

        m.last_login_ip = "192.0.2.1"
        expect(m).to be_valid

        m.last_login_ip = "2001:db8::dead:beaf"
        expect(m).to be_invalid
        expect(m.errors[:last_login_ip]).to eq ["is invalid"]

        m.last_login_ip = "www.example.com"
        expect(m).to be_invalid
        expect(m.errors[:last_login_ip]).to eq ["is invalid"]
      end
    end

    context "when version v6 is specified" do
      it "should be accept only v6 ip address" do
        DummyModel.validates_ip_address_of :last_login_ip, version: :v6

        m = DummyModel.new

        m.last_login_ip = "192.0.2.1"
        expect(m).to be_invalid
        expect(m.errors[:last_login_ip]).to eq ["is invalid"]

        m.last_login_ip = "2001:db8::dead:beaf"
        expect(m).to be_valid

        m.last_login_ip = "www.example.com"
        expect(m).to be_invalid
        expect(m.errors[:last_login_ip]).to eq ["is invalid"]
      end
    end

    context "when version v4/v6 are specified" do
      it "should be accept only v4/v6 ip address" do
        DummyModel.validates_ip_address_of :last_login_ip, version: %i[v4 v6]

        m = DummyModel.new

        m.last_login_ip = "192.0.2.1"
        expect(m).to be_valid

        m.last_login_ip = "2001:db8::dead:beaf"
        expect(m).to be_valid

        m.last_login_ip = "www.example.com"
        expect(m).to be_invalid
        expect(m.errors[:last_login_ip]).to eq ["is invalid"]
      end
    end
  end
end
