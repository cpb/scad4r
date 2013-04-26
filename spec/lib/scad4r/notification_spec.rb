require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'scad4r/notification'

module Scad4r
  describe Notification do
    let(:notifications) { described_class.parse(scad4r_result) }
    subject { notifications }

    let(:high_priority) { 2}
    let(:medium_priority) { 1 }
    let(:low_priority) { -1 }

    let(:mock_result) {
      {error: nil,
       echos: nil,
       warnings: nil,
       real: nil}
    }

    context "with output path" do
      subject { notifications.last }
      let(:scad4r_result) { mock_result.merge(output: Pathname.new("tmp/aruba/cube.stl"), real: 0)}

      its(:message) { should include("-> tmp/aruba/cube.stl")}
    end

    context "with errors" do
      subject { notifications.first }
      let(:scad4r_result) { mock_result.merge(error: "error message") }

      its(:priority) { should eql(high_priority) }
      its(:title) { should eql("openscad ERROR") }
      its(:image) { should eql(:error) }
      its(:message) { should eql(scad4r_result[:error]) }
    end

    context "with timings" do
      subject { notifications.first }
      let(:scad4r_result) { mock_result.merge(real: "0m0.555s") }

      its(:priority) { should eql(low_priority) }
      its(:title) { should include("SUCCESS") }
      its(:image) { should eql(:success) }
      its(:message) { should eql("0m0.555s") }
    end

    context "with one warning" do
      subject { notifications.first }
      let(:scad4r_result) { mock_result.merge(warnings: ["the warning message"]) }

      its(:priority) { should eql(medium_priority) }
      its(:title) { should include("WARNING") }
      its(:image) { should eql(:error) }
      its(:message) { should eql(scad4r_result[:warnings].first) }
    end

    context "with many warnings" do
      let(:scad4r_result) { mock_result.merge(warnings: ["the warning message", "somany"]) }

      it {should have(2).items}
    end

    context "with one echo" do
      subject { notifications.first }
      let(:scad4r_result) { mock_result.merge(echos: ["the echo message"]) }

      its(:priority) { should eql(medium_priority) }
      its(:title) { should include("ECHO") }
      its(:image) { should eql(:success) }
      its(:message) { should eql(scad4r_result[:echos].first) }
    end

    context "with many echos" do
      let(:scad4r_result) { mock_result.merge(echos: ["the echo message", "somany"]) }

      it {should have(2).items}
    end
  end
end
