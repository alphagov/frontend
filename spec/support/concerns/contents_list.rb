RSpec.shared_examples "it can have a contents list" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  it "memoises the contents to avoid repeated processing and extraction" do
    contents_list = described_class.new(content_store_response)

    expect(contents_list).to receive(:show_contents_list?).and_return(true).once
    contents_list.contents
    contents_list.contents
  end

  it "extracts a single H2" do
    overrides = {
      "details" => {
        "body" => "<h2 id=\"custom\">A heading</h2>",
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).contents_items).to eq([{ text: "A heading", id: "custom" }])
  end

  it "removes trailing colons from headings" do
    overrides = {
      "details" => {
        "body" => "<h2 id=\"custom\">List:</h2>",
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).contents_items).to eq([{ text: "List", id: "custom" }])
  end

  it "removes only trailing colons from headings" do
    overrides = {
      "details" => {
        "body" => "<h2 id=\"custom\">Part 2: List:</h2>",
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).contents_items).to eq([{ text: "Part 2: List", id: "custom" }])
  end

  it "ignores headings without an id" do
    overrides = {
      "details" => {
        "body" => "<h2>John Doe</h2>",
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).contents_items).to be_empty
  end

  it "extracts multiple h2s" do
    overrides = {
      "details" => {
        "body" => "<h2 id=\"one\">One</h2>
                   <p>One is the loneliest number</p>
                   <h2 id=\"two\">Two</h2>
                   <p>Two can be as bad as one</p>
                   <h2 id=\"three\">Three</h2>
                   <h3>Pi</h3>
                   <h2 id=\"four\">Four</h2>",
      },
    }
    content_store_response.deep_merge!(overrides)

    result = [
      { text: "One", id: "one" },
      { text: "Two", id: "two" },
      { text: "Three", id: "three" },
      { text: "Four", id: "four" },
    ]

    expect(described_class.new(content_store_response).contents_items).to eq(result)
  end

  it "displays content list if there is an H2" do
    overrides = {
      "details" => {
        "body" => "<h2 id='one'>One</h2>",
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).show_contents_list?).to be(true)
  end

  it "displays no contents list if there is no H2 and first item character count is less than 415" do
    overrides = {
      "details" => {
        "body" => "<div>
                     <p>#{Faker::Lorem.characters(number: 400)}</p>
                   </div>",
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).show_contents_list?).to be(false)
  end

  it "displays contents list if the first item's character count is above 415, including a list" do
    overrides = {
      "details" => {
        "body" => "<h2 id='one'>One</h2>
                   <p>#{Faker::Lorem.characters(number: 40)}</p>
                   <ul>
                     <li>#{Faker::Lorem.characters(number: 100)}</li>
                     <li>#{Faker::Lorem.characters(number: 100)}</li>
                     <li>#{Faker::Lorem.characters(number: 200)}</li>
                   </ul>
                   <p>#{Faker::Lorem.characters(number: 40)}</p>
                   <h2 id='two'>Two</h2>
                   <p>#{Faker::Lorem.sentence}</p>",
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).show_contents_list?).to be(true)
  end

  it "does not display contents list if the first item's character count is less than 415" do
    overrides = {
      "details" => {
        "body" => "<p>#{Faker::Lorem.characters(number: 20)}</p>
                   <p>#{Faker::Lorem.characters(number: 20)}</p>
                   <p>#{Faker::Lorem.sentence}</p>",
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).show_contents_list?).to be(false)
  end

  it "displays contents list if number of table rows in the first item is more than 13" do
    def body
      base = "<h2 id='one'>One</h2><table>\n<tbody>\n"
      14.times do
        base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}</td>\n</tr>\n"
      end
      base += "</tbody>\n</table><h2 id='two'>Two</h2>"
    end

    overrides = {
      "details" => {
        "body" => body,
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).show_contents_list?).to be(true)
  end

  it "does not display contents list if number of table rows in the first item is less than 13" do
    overrides = {
      "details" => {
        "body" => "<table>\n<tbody>\n
                   <tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n
                   <tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n
                   </tbody>\n</table>",
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).show_contents_list?).to be(false)
  end

  it "displays contents list if image is present and the first_item's character count is over 224" do
    overrides = {
      "details" => {
        "body" => "<h2 id='one'>One</h2>
                   <div class='img'><img src='www.gov.uk/img.png'></div>
                   <p>#{Faker::Lorem.characters(number: 225)}</p>
                   <h2 id='two'>Two</h2>
                   <p>#{Faker::Lorem.sentence}</p>",
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).show_contents_list?).to be(true)
  end

  it "displays contents list if an image and a table with more than 6 rows are present in the first item" do
    def body
      base = "<h2 id='one'>One</h2><div class='img'>
        <img src='www.gov.uk/img.png'></div><table>\n<tbody>\n"
      7.times do
        base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n"
      end
      base += "</tbody>\n</table><h2 id='two'>Two</h2>"
    end

    overrides = {
      "details" => {
        "body" => body,
      },
    }
    content_store_response.deep_merge!(overrides)

    expect(described_class.new(content_store_response).show_contents_list?).to be(true)
  end
end
