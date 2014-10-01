require 'spec_helper'

describe "class PostReader" do
  let(:fourteen) { PostReader.new("views/test_posts/fourteen/*") }
  let(:five) { PostReader.new("views/test_posts/five/*") }
  let(:two) { PostReader.new("views/test_posts/two/*") }
  let(:one) { PostReader.new("views/test_posts/one/*") }
  let(:empty) { PostReader.new("views/test_posts/empty/*")}

  describe "initialize" do
    it "initializes an array of the appropriate number of posts" do
      expect(fourteen.count).to eq 14
      expect(five.count).to eq 5
      expect(two.count).to eq 2
      expect(one.count).to eq 1
      expect(empty.count).to eq 0
    end
  end

  describe "posts methods" do
    it "slices most recent posts" do
      expect(fourteen.most_recent(3).length).to eq 3
      expect(two.most_recent(3).length).to eq 2
      expect(empty.most_recent(3).length).to eq 0
    end

    it "slices array from arbitrary point" do
      expect(fourteen.slice(3,5).length).to eq 5
      expect(five.slice(3,5).length).to eq 2
    end

    it "can check for empty array" do
      expect(fourteen.empty?).to eq false
      expect(empty.empty?).to eq true
    end
  end

  describe "page methods" do
    it "identifies first page from url" do
      expect(fourteen.first_page?(0)).to eq true
      expect(fourteen.first_page?(1)).to eq true
      expect(fourteen.first_page?(2)).to eq false
    end

    it "identifies last page from url" do
      expect(fourteen.last_page?(fourteen.last_page)).to eq true
      expect(fourteen.last_page?(fourteen.last_page + 100)).to eq true
      expect(fourteen.last_page?(0)).to eq false
      expect(one.last_page?(1)).to eq true
      # expect(one.last_page(0)).to eq true DOES THIS NEED TO PASS?
    end
  end

  describe "index heading generators" do
    describe "#first_index_heading" do
      it "returns correct heading for empty array" do
       expect(empty.first_index_heading).to eq "I haven't made any posts yet!"
       expect(one.first_index_heading).to eq "My one lonely post:"
       expect(two.first_index_heading).to eq "All 2 posts:"
       expect(fourteen.first_index_heading).to eq "Latest #{PostReader::PER_PAGE} posts:"
      end
    end

    describe "later_index_heading" do
      # these tests are a pain in the ass
    end
  end

  describe "#footer_links(page)" do
  end

end
