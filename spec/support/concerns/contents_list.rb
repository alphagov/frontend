RSpec.shared_examples "it can have a contents list" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:contents_list) { described_class.new(content_store_response) }

  it "memoises the contents to avoid repeated processing and extraction" do
    expect(contents_list).to receive(:show_contents_list?).and_return(true).once

    contents_list.contents
    contents_list.contents
  end

  it "does not display contents list if body is not present" do
    content_store_response["details"]["body"] = nil

    expect(contents_list.contents).to be_empty
    expect(contents_list.show_contents_list?).to be(false)
  end

  context "when there are H2s present with ids" do
    it "includes all H2s with ids in the contents list" do
      body = Nokogiri::HTML(content_store_response["details"]["body"])
      expected_headings = body.css("h2").map do |heading|
        extract_heading(heading)
      end

      expect(contents_list.contents_items).to eq(expected_headings)
    end

    it "removes trailing colons" do
      content_store_response["details"]["body"] = "<h2 id=\"custom\">List:</h2>"

      expect(contents_list.contents_items.first).to eq({ text: "List", id: "custom" })
    end

    it "only removes trailing colons if H2s have multiple colons" do
      content_store_response["details"]["body"] = "<h2 id=\"custom\">Part 2: List:</h2>"

      expect(contents_list.contents_items.first).to eq({ text: "Part 2: List", id: "custom" })
    end
  end

  context "when there are H2s present but do not have ids" do
    context "when they do not have sibling elements" do
      it "does not display contents list" do
        content_store_response["details"]["body"] = "<h2>John Doe</h2><h2>John Doe</h2>"

        expect(contents_list.contents_items).to be_empty
        expect(contents_list.show_contents_list?).to be(false)
      end
    end

    context "when they have sibling elements (p, u or ol)" do
      it "does not display contents list when first item's character count < 415" do
        content_store_response["details"]["body"] = "<h2>John Doe</h2><p>Here is a paragraph.</p>"

        expect(contents_list.contents_items).to be_empty
        expect(contents_list.show_contents_list?).to be(false)
      end

      it "displays contents list when the first item's character count > 415, including a list" do
        html = "<h2>One</h2>
                <p>#{Faker::Lorem.characters(number: 40)}</p>
                <ul>
                  <li>#{Faker::Lorem.characters(number: 100)}</li>
                  <li>#{Faker::Lorem.characters(number: 100)}</li>
                  <li>#{Faker::Lorem.characters(number: 200)}</li>
                </ul>
                <p>#{Faker::Lorem.characters(number: 40)}</p>
                <h2 id='two'>Two</h2>
                <p>#{Faker::Lorem.sentence}</p>"
        content_store_response["details"]["body"] = html

        expect(contents_list.contents_items.present?).to be(true)
        expect(contents_list.show_contents_list?).to be(true)
      end

      it "does not display contents list when first item contains a table with less than 13 rows" do
        html = "<h2>One</h2>
                <table>\n<tbody>\n
                <tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n
                <tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n
                </tbody>\n</table>"
        content_store_response["details"]["body"] = html

        expect(contents_list.contents_items).to be_empty
        expect(contents_list.show_contents_list?).to be(false)
      end

      it "displays contents list when first item contains a table with more than 13 rows" do
        def body
          base = "<h2>One</h2><table>\n<tbody>\n"
          14.times do
            base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}</td>\n</tr>\n"
          end
          base += "</tbody>\n</table><h2 id='two'>Two</h2>"
        end
        content_store_response["details"]["body"] = body

        expect(contents_list.contents_items.present?).to be(true)
        expect(contents_list.show_contents_list?).to be(true)
      end

      it "does not display contents list if an image and a table with less than 6 rows are present in the first item" do
        html = "<h2>One</h2>
                <div class='img'>
                <img src='www.gov.uk/img.png'></div>
                <table>\n<tbody>\n
                <tr>\n<td>One</td></tr>\n</tbody>\n
                </table>
                <h2>Two</h2>"
        content_store_response["details"]["body"] = html

        expect(contents_list.contents_items).to be_empty
        expect(contents_list.show_contents_list?).to be(false)
      end

      it "displays contents list if an image and a table with more than 6 rows are present in the first item" do
        def body
          base = "<h2>One</h2><div class='img'>
            <img src='www.gov.uk/img.png'></div><table>\n<tbody>\n"
          7.times do
            base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n"
          end
          base += "</tbody>\n</table><h2>Two</h2>"
        end

        expect(contents_list.contents_items.present?).to be(true)
        expect(contents_list.show_contents_list?).to be(true)
      end
    end
  end

  context "when H2s are not present" do
    it "does not display contents list when the first item's character count > 415, including a list" do
      html = "<p>#{Faker::Lorem.characters(number: 40)}</p>
              <ul>
                <li>#{Faker::Lorem.characters(number: 100)}</li>
                <li>#{Faker::Lorem.characters(number: 100)}</li>
                <li>#{Faker::Lorem.characters(number: 200)}</li>
              </ul>
              <p>#{Faker::Lorem.characters(number: 40)}</p>
              <p>#{Faker::Lorem.characters(number: 40)}</p>"
      content_store_response["details"]["body"] = html

      expect(contents_list.contents_items).to be_empty
      expect(contents_list.show_contents_list?).to be(false)
    end

    it "does not display contents list when first item contains a table with more than 13 rows" do
      def body
        base = "<table>\n<tbody>\n"
        14.times do
          base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}</td>\n</tr>\n"
        end
        base += "</tbody>\n</table>"
      end
      content_store_response["details"]["body"] = body

      expect(contents_list.contents_items).to be_empty
      expect(contents_list.show_contents_list?).to be(false)
    end

    it "does not display contents list if an image and a table with more than 6 rows are present in the first item" do
      def body
        base = "<div class='img'>
          <img src='www.gov.uk/img.png'></div><table>\n<tbody>\n"
        7.times do
          base += "<tr>\n<td>#{Faker::Lorem.word}</td>\n<td>#{Faker::Lorem.word}/td>\n</tr>\n"
        end
        base += "</tbody>\n</table>"
      end
      content_store_response["details"]["body"] = body

      expect(contents_list.contents_items).to be_empty
      expect(contents_list.show_contents_list?).to be(false)
    end
  end

  def extract_heading(heading)
    { text: heading.text.gsub(/:$/, ""), id: heading.attribute("id").value }
  end
end
