RSpec.describe GovspeakContentsList do
  let(:content_item) { { "title" => "thing" }.extend(described_class) }

  it "memoises the contents to avoid repeated processing and extraction" do
    allow(content_item).to receive(:body).and_return('<h2 id="custom">A heading</h2>')

    expect(content_item).to receive(:show_contents_list?).and_return(true).once

    # Call contents twice to confirm memoisation
    content_item.contents
    content_item.contents
  end

  it "extracts a single h2" do
    allow(content_item).to receive(:body).and_return('<h2 id="custom">A heading</h2>')

    expect(content_item.contents_items).to eq([{ text: "A heading", id: "custom" }])
  end

  it "removes trailing colons from headings" do
    allow(content_item).to receive(:body).and_return('<h2 id="custom">List:</h2>')
    expect(content_item.contents_items).to eq([{ text: "List", id: "custom" }])
  end

  it "removes only trailing colons from headings" do
    allow(content_item).to receive(:body).and_return('<h2 id="custom">Part 2: List:</h2>')
    expect(content_item.contents_items).to eq([{ text: "Part 2: List", id: "custom" }])
  end

  it "ignores headings without an id" do
    allow(content_item).to receive(:body).and_return("<h2>John Doe</h2>")
    expect(content_item.contents_items).to eq([])
  end

  it "extracts multiple h2s" do
    allow(content_item).to receive(:body).and_return('<h2 id="one">One</h2>
         <p>One is the loneliest number</p>
         <h2 id="two">Two</h2>
         <p>Two can be as bad as one</p>
         <h2 id="three">Three</h2>
         <h3>Pi</h3>
         <h2 id="four">Four</h2>')

    expect(content_item.contents_items).to eq([
      { text: "One", id: "one" },
      { text: "Two", id: "two" },
      { text: "Three", id: "three" },
      { text: "Four", id: "four" },
    ])
  end

  it "displays content list if there is an H2" do
    allow(content_item).to receive(:body).and_return("<h2 id='one'>One</h2>")
    expect(content_item.show_contents_list?).to be(true)
  end

  it "displays no contents list if there is no H2 and first item is less than 415" do
    allow(content_item).to receive(:body).and_return("<div>
          <p>#{Faker::Lorem.characters(number: 400)}</p>
        </div>
        ")
    expect(content_item.show_contents_list?).to be(false)
  end

  it "displays contents list if the first item's character count is above 415, including a list" do
    allow(content_item).to receive(:body).and_return(
      "<h2 id='one'>One</h2>
         <p>#{Faker::Lorem.characters(number: 40)}</p>
         <ul>
           <li>#{Faker::Lorem.characters(number: 100)}</li>
           <li>#{Faker::Lorem.characters(number: 100)}</li>
           <li>#{Faker::Lorem.characters(number: 200)}</li>
         </ul>
         <p>#{Faker::Lorem.characters(number: 40)}</p>
         <h2 id='two'>Two</h2>
         <p>#{Faker::Lorem.sentence}</p>",
    )
    expect(content_item.show_contents_list?).to be(true)
  end

  it "does not display contents list if the first item's character count is less than 415" do
    allow(content_item).to receive(:body).and_return(
      "<p>#{Faker::Lorem.characters(number: 20)}</p>
         <p>#{Faker::Lorem.characters(number: 20)}</p>
         <p>#{Faker::Lorem.sentence}</p>",
    )
    expect(content_item.show_contents_list?).to be(false)
  end

  it "displays contents list if number of table rows in the first item is more than 13" do
    base = "<h2 id='one'>One</h2><table>\n<tbody>\n"
    14.times do
      base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}</td>\n</tr>\n"
    end
    base += "</tbody>\n</table><h2 id='two'>Two</h2>"

    allow(content_item).to receive(:body).and_return(base)

    expect(content_item.show_contents_list?).to be(true)
  end

  it "does not display contents list if number of table rows in the first item is less than 13" do
    allow(content_item).to receive(:body).and_return(
      "<table>\n<tbody>\n
        <tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n
        <tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n
        </tbody>\n</table>",
    )
    expect(content_item.show_contents_list?).to be(false)
  end

  it "displays contents list if image is present and the first_item's character count is over 224" do
    allow(content_item).to receive(:body).and_return(
      "<h2 id='one'>One</h2>
        <div class='img'><img src='www.gov.uk/img.png'></div>
        <p>#{Faker::Lorem.characters(number: 225)}</p>
        <h2 id='two'>Two</h2>
        <p>#{Faker::Lorem.sentence}</p>",
    )
    expect(content_item.show_contents_list?).to be(true)
  end

  it "displays contents list if an image and a table with more than 6 rows are present in the first item" do
    base = "<h2 id='one'>One</h2><div class='img'>
          <img src='www.gov.uk/img.png'></div><table>\n<tbody>\n"
    7.times do
      base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}</td>\n</tr>\n"
    end
    base += "</tbody>\n</table><h2 id='two'>Two</h2>"
    allow(content_item).to receive(:body).and_return(base)
    expect(content_item.show_contents_list?).to be(true)
  end
end
