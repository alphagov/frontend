RSpec.describe GovspeakYoutubeVideoRemover do
  subject(:result) { described_class.new(html).remove }

  context "with a standalone YouTube link" do
    let(:html) do
      <<~HTML
        <h2>Voting by post</h2>
        <p><a href="https://www.youtube.com/watch?v=abc123">How to complete your postal vote</a></p>
        <p>Return your postal vote as soon as possible.</p>
      HTML
    end

    it "removes the paragraph that Govspeak would expand into a video" do
      expect(result).not_to include("youtube.com")
      expect(result).not_to include("How to complete your postal vote")
      expect(result).to include("Voting by post")
      expect(result).to include("Return your postal vote as soon as possible.")
    end
  end

  context "with a standalone YouTube link surrounded by punctuation" do
    let(:html) do
      '<p>"<a href="https://youtu.be/abc123">Watch the video</a>."</p>'
    end

    it "removes the paragraph to match Govspeak's expansion behaviour" do
      expect(result).to be_empty
    end
  end

  context "with a YouTube link alongside other content" do
    let(:html) do
      '<p>You can <a href="https://www.youtube.com/watch?v=abc123">watch the video on YouTube</a>.</p>'
    end

    it "keeps the paragraph and link" do
      expect(result).to include("youtube.com")
      expect(result).to include("You can")
    end
  end

  context "with a YouTube link that has embedding disabled" do
    let(:html) do
      '<p><a href="https://www.youtube.com/watch?v=abc123" data-youtube-player="off">Watch on YouTube</a></p>'
    end

    it "keeps the link" do
      expect(result).to include("youtube.com")
    end
  end

  context "with a YouTube playlist link" do
    let(:html) do
      '<p><a href="https://www.youtube.com/playlist?list=abc123">Watch the playlist</a></p>'
    end

    it "keeps the link" do
      expect(result).to include("youtube.com")
    end
  end

  context "with a non-YouTube link" do
    let(:html) do
      '<p><a href="https://www.gov.uk/register-to-vote">Register to vote</a></p>'
    end

    it "keeps the link" do
      expect(result).to include("https://www.gov.uk/register-to-vote")
    end
  end
end
