RSpec.describe PostalVoteVideoContentRemover do
  subject(:result) { described_class.new(html).remove }

  context "with a standalone YouTube link and no video content end marker" do
    let(:html) do
      <<~HTML
        <h2>Voting by post</h2>
        <p><a href="https://www.youtube.com/watch?v=abc123">How to complete your postal vote</a></p>
        <p>Return your postal vote as soon as possible.</p>
      HTML
    end

    it "removes only the paragraph that Govspeak would expand into a video" do
      expect(result).not_to include("youtube.com")
      expect(result).not_to include("How to complete your postal vote")
      expect(result).to include("Voting by post")
      expect(result).to include("Return your postal vote as soon as possible.")
    end
  end

  context "with experimental content before the existing postal vote content" do
    let(:html) do
      <<~HTML
        <h2>Voting by post</h2>
        <p><a href="https://www.youtube.com/watch?v=abc123">How to complete your postal vote</a></p>
        <h2 id="what-is-a-postal-vote">What is a postal vote?</h2>
        <p>This video explains what postal voting is, who can apply for a postal vote and what happens to your vote on polling day.</p>
        <p>GOV.UK • 1 minutes 48 seconds</p>
        <p>Transcript</p>
        <p>A postal vote allows you to vote without having to visit a polling station.</p>
        <p>To apply, search ‘apply postal vote’ on GOV.UK.</p>
        <p>
          You must apply for a postal vote if you want to vote by post, for example if:
        </p>
        <ul>
          <li>you're away from home</li>
          <li>you're abroad and want to vote in England, Scotland or Wales</li>
        </ul>
        <h2>Apply for a postal vote</h2>
        <p>This is existing content that must remain.</p>
      HTML
    end

    it "removes the video and all experimental content before the end marker" do
      expect(result).not_to include("youtube.com")
      expect(result).not_to include("What is a postal vote?")
      expect(result).not_to include("This video explains")
      expect(result).not_to include("1 minutes 48 seconds")
      expect(result).not_to include("Transcript")
      expect(result).not_to include("A postal vote allows you")
      expect(result).not_to include("search ‘apply postal vote’")
    end

    it "preserves the end marker and content before and after the video content" do
      expect(result).to include("Voting by post")
      expect(result).to include("You must apply for a postal vote")
      expect(result).to include("you're away from home")
      expect(result).to include("Apply for a postal vote")
      expect(result).to include("This is existing content that must remain.")
    end
  end

  context "when the expected existing content has changed" do
    let(:html) do
      <<~HTML
        <p><a href="https://www.youtube.com/watch?v=abc123">Watch the video</a></p>
        <p>Supporting content remains when the end marker cannot be found.</p>
        <p>You can apply for a postal vote if you want to vote by post.</p>
      HTML
    end

    it "safely removes only the video paragraph" do
      expect(result).not_to include("youtube.com")
      expect(result).to include("Supporting content remains")
      expect(result).to include("You can apply for a postal vote")
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
