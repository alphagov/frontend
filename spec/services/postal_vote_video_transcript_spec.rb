RSpec.describe PostalVoteVideoTranscript do
  subject(:transcript) { described_class.new(html) }

  let(:end_marker) { PostalVoteVideoContentRemover::VIDEO_CONTENT_END_MARKER }

  context "when the transcript and end markers are present in order" do
    let(:html) do
      <<~HTML
        <p><a href="https://www.youtube.com/watch?v=abc123">Watch the video</a></p>
        <h2>What is a postal vote?</h2>
        <p>Transcript</p>
        <p>This is the first transcript paragraph.</p>
        <p>This is the final transcript paragraph.</p>
        <p>
          #{end_marker}
        </p>
        <ul><li>Existing postal vote content</li></ul>
      HTML
    end

    it "identifies the transcript" do
      expect(transcript).to be_present
    end

    it "keeps the video content before the transcript" do
      expect(transcript.before_html).to include("youtube.com")
      expect(transcript.before_html).to include("What is a postal vote?")
      expect(transcript.before_html).not_to include("Transcript")
    end

    it "extracts only the transcript body" do
      expect(transcript.transcript_html).to include("first transcript paragraph")
      expect(transcript.transcript_html).to include("final transcript paragraph")
      expect(transcript.transcript_html).not_to include("<p>Transcript</p>")
      expect(transcript.transcript_html).not_to include(end_marker)
    end

    it "keeps the end marker and subsequent content after the transcript" do
      expect(transcript.after_html).to include(end_marker)
      expect(transcript.after_html).to include("Existing postal vote content")
    end
  end

  context "when the transcript marker is missing" do
    let(:html) do
      <<~HTML
        <p>Introductory content</p>
        <p>#{end_marker}</p>
      HTML
    end

    it "does not extract a transcript" do
      expect(transcript).not_to be_present
    end
  end

  context "when the end marker is missing" do
    let(:html) do
      <<~HTML
        <p>Transcript</p>
        <p>Transcript content</p>
      HTML
    end

    it "does not extract a transcript" do
      expect(transcript).not_to be_present
    end
  end

  context "when the end marker appears before the transcript marker" do
    let(:html) do
      <<~HTML
        <p>#{end_marker}</p>
        <p>Transcript</p>
        <p>Transcript content</p>
      HTML
    end

    it "does not extract a transcript" do
      expect(transcript).not_to be_present
    end
  end
end
