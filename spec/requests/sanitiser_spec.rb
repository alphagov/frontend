RSpec.describe "Sanitiser" do
  context "with query being correct percent-encoded UTF-8 string" do
    it "does not raise exception" do
      get "/development?%41"
      expect(response).to have_http_status(:ok)
    end
  end

  context "with query being incorrect percent-encoded UTF-8 string" do
    it "raises SanitisingError" do
      expect { get "/development?%AD" }.to raise_error(Sanitiser::Strategy::SanitisingError)
    end
  end

  context "with cookie key being correct UTF-8" do
    it "does not raise exception" do
      get "/development", headers: { Cookie: "\x41=value" }
      expect(response).to have_http_status(:ok)
    end
  end

  context "with cookie key being incorrect UTF-8" do
    it "raises exception" do
      expect { get "/development", headers: { Cookie: "\xAD=value" } }
        .to raise_error(ArgumentError, "invalid byte sequence in UTF-8")
    end
  end

  context "with cookie value being correct UTF-8" do
    it "does not raise exception" do
      get "/development", headers: { Cookie: "key=\x41" }
      expect(response).to have_http_status(:ok)
    end
  end

  context "with cookie value being incorrect UTF-8" do
    it "raises exception" do
      expect { get "/development", headers: { Cookie: "key=\xAD" } }
        .to raise_error(ArgumentError, "invalid byte sequence in UTF-8")
    end
  end

  context "with cookie path being correct UTF-8" do
    it "does not raise exception" do
      get "/development", headers: { Cookie: "key=value; Path=/\x41" }
      expect(response).to have_http_status(:ok)
    end
  end

  context "with cookie path being incorrect UTF-8" do
    it "raises exception" do
      expect { get "/development", headers: { Cookie: "key=value; Path=/\xAD" } }
        .to raise_error(ArgumentError, "invalid byte sequence in UTF-8")
    end
  end

  context "with cookie path being correct percent-encoded UTF-8" do
    it "does not raise exception" do
      get "/development", headers: { Cookie: "key=value; Path=/%41" }
      expect(response).to have_http_status(:ok)
    end
  end

  context "with cookie path being incorrect percent-encoded UTF-8" do
    it "raises SanitisingError" do
      expect { get "/development", headers: { Cookie: "key=value; Path=/%AD" } }
        .to raise_error(Sanitiser::Strategy::SanitisingError)
    end
  end

  context "with referrer header being correct percent-encoded UTF-8" do
    it "does not raise exception" do
      get "/development", headers: { Referer: "http://example.com/?%41" }
      expect(response).to have_http_status(:ok)
    end
  end

  context "with referrer header being incorrect percent-encoded UTF-8" do
    it "does not raise exception" do
      get "/development", headers: { Referer: "http://example.com/?%AD" }
      expect(response).to have_http_status(:ok)
    end
  end
end
